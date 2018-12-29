//
//  IDFileManager.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "IDFileManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "PathUtility.h"

@implementation IDFileManager


- (NSURL *)tempFileURL
{
    NSString *path = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSInteger i = 0;
    while(path == nil || [fm fileExistsAtPath:path]){
        path = [NSString stringWithFormat:@"%@output%ld.mov", NSTemporaryDirectory(), (long)i];
        i++;
    }
    return [NSURL fileURLWithPath:path];
}

- (void) removeFile:(NSURL *)fileURL
{
    NSString *filePath = [fileURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        if(error){
            NSLog(@"error removing file: %@", [error localizedDescription]);
        }
    }
}

- (void) copyFileToDocuments:(NSURL *)fileURL
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/output_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
    NSError	*error;
    [[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error];
    if(error){
        NSLog(@"error copying file: %@", [error localizedDescription]);
    }
}

- (void)copyFileToCameraRoll:(NSURL *)fileURL
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if(![library videoAtPathIsCompatibleWithSavedPhotosAlbum:fileURL]){
        NSLog(@"video incompatible with camera roll");
    }
    [library writeVideoAtPathToSavedPhotosAlbum:fileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if(error){
            NSLog(@"Error: Domain = %@, Code = %@", [error domain], [error localizedDescription]);
        } else if(assetURL == nil){
            
            //It's possible for writing to camera roll to fail, without receiving an error message, but assetURL will be nil
            //Happens when disk is (almost) full
            NSLog(@"Error saving to camera roll: no error message, but no url returned");
            
        } else {
            //remove temp file
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
            if(error){
                NSLog(@"error: %@", [error localizedDescription]);
            }
            
        }
    }];
}

#pragma mark - Convert

- (void)convertMovToMP4WithSource:(NSURL *)source complete:(void(^)(AVAssetExportSessionStatus status, NSString *outputPath))block
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:source options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
//    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
    if ([compatiblePresets containsObject:AVAssetExportPreset960x540]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset960x540];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        
        NSString *exportPath = [NSString stringWithFormat:@"%@tim_ugc_video_%@.mp4", NSTemporaryDirectory(), [formatter stringFromDate:[NSDate date]]];
        
        NSLog(@"%@", exportPath);
        exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        NSArray *supportedTypeArray = exportSession.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            exportSession.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            exportSession.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        // 如果没有缓存目录，则创建一个
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        /* 看 TZ 的代码，这里应该要加入修正视频转向的代码 */
        
        AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:avAsset];
        if (videoComposition.renderSize.width) {
            // 修正视频转向
            exportSession.videoComposition = videoComposition;
        }
        
        // 视频转换成功或失败，都要把源文件删了
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        if (block) block(AVAssetExportSessionStatusFailed, nil);
                    } break;
                        
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"Export cancelled!");
                        if (block) block(AVAssetExportSessionStatusCancelled, nil);
                    }break;
                        
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"转换成功");
                        if (block) block(AVAssetExportSessionStatusCompleted, exportPath);
                    } break;
                        
                    default:
                        break;
                }
            });
        }];
    }
}

// 获取优化后的视频转向信息
- (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

// 获取视频角度
- (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
