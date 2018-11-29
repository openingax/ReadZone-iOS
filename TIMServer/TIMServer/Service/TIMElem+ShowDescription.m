//
//  TIMElem+ShowDescription.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ShowDescription.h"
#import "NSDate+Common.h"
#import "TSIMAdapter.h"
#import "NSMutableDictionary+Json.h"
#import "PathHeaders.h"
#import "TSIMMsg.h"
#import "TSDebugMarco.h"
#import "NSString+Common.h"
#import "UIImage+Common.h"

@implementation TIMElem (ShowDescription)

- (NSString *)showDescriptionOf:(TSIMMsg *)msg {
    return [self description];
}

- (BOOL)isSystemFace {
    return NO;
}

@end


@implementation TIMTextElem (ShowDescription)

- (NSString *)showDescriptionOf:(TSIMMsg *)msg {
    return [self text];
}

@end


@implementation TIMImageElem (ShowDescription)

- (void)asyncThumbImage:(AsyncGetThumbImageBlock)block inMsg:(TSIMMsg *)msg {
    if (!block)
    {
        return;
    }
    
    // 本地存在
    NSString *thumpPath = [msg stringForKey:kIMAMSG_Image_ThumbPath];
    if ([PathUtility isExistFile:thumpPath])
    {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:thumpPath];
        block(thumpPath, img, YES, NO);
        return;
    }
    
    if (self.imageList.count > 0)
    {
        for (TIMImage *timImage in self.imageList)
        {
//            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            if (timImage.type == TIM_IMAGE_TYPE_LARGE)
            {
                // 解析大小
                NSInteger width = timImage.width;
                NSInteger height = timImage.height;
                NSString *url = timImage.url;
                
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/height, kChatPicThumbMaxWidth/width);
                
                
                NSInteger tw = (NSInteger) (width * scale + 1);
                NSInteger th = (NSInteger) (height * scale + 1);
                [msg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [msg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *nsTmpDir = NSTemporaryDirectory();
                NSString *imageThumbPath = [NSString stringWithFormat:@"%@/image_%@_ThumbImage", nsTmpDir, timImage.uuid];
                BOOL isDirectory = NO;
                
                if ([fileManager fileExistsAtPath:imageThumbPath isDirectory:&isDirectory]  && isDirectory == NO)
                {
                    // 本地存在
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageThumbPath];
                    [msg addString:imageThumbPath forKey:kIMAMSG_Image_ThumbPath];
                    
                    block(url, image, YES, NO);
                }
                else
                {
                    // 本地不存在，下载原图
                    [timImage getImage:imageThumbPath succ:^{
                        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageThumbPath];
                        block(url, image, YES, YES);
                    } fail:^(int code, NSString *err) {
                        block(url, nil, NO, YES);
                    }];
                }
                
                break;
            }
        }
    }
    
    
    NSString *filePath = self.path;
    if (![NSString isEmpty:filePath])
    {
        // NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f_Size_%d_%d", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate], (int)picThumbWidth, (int)picThumbHeight];
        // 检查本地是否存储了
        BOOL exist = [PathUtility isExistFile:filePath];
        if (exist)
        {
            // 原图地址
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
            
            CGFloat scale = 1;
            scale = MIN(kChatPicThumbMaxHeight/image.size.height, kChatPicThumbMaxWidth/image.size.width);
            
            CGFloat picHeight = image.size.height;
            CGFloat picWidth = image.size.width;
            NSInteger width = (NSInteger) (picWidth * scale + 1);
            NSInteger height = (NSInteger) (picHeight * scale + 1);
            
            image = [image thumbnailWithSize:CGSizeMake(width, height)];
            block(filePath, image, YES, NO);
            
            [msg addInteger:width forKey:kIMAMSG_Image_ThumbWidth];
            [msg addInteger:height forKey:kIMAMSG_Image_ThumbHeight];
            
            NSString *nsTmpDIr = NSTemporaryDirectory();
            NSString *imageThumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
            
            [[NSFileManager defaultManager] createFileAtPath:imageThumbPath contents:UIImageJPEGRepresentation(image, 1) attributes:nil];
        }
    }
    else
    {
        DebugLog(@"逻辑不可达");
        
    }
}

- (UIImage *)getThumbImageInMsg:(TSIMMsg *)msg {
    NSString *thumpPath = [msg stringForKey:kIMAMSG_Image_ThumbPath];
    if ([PathUtility isExistFile:thumpPath])
    {
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:thumpPath];
        return img;
    }
    
    if (self.imageList.count > 0)
    {
        for (TIMImage *timImage in self.imageList)
        {
//            if (timImage.type == TIM_IMAGE_TYPE_THUMB)
            if (timImage.type == TIM_IMAGE_TYPE_LARGE)
            {
                // 解析大小
                NSInteger width = timImage.width;
                NSInteger height = timImage.height;
                
                CGFloat scale = 1;
                scale = MIN(kChatPicThumbMaxHeight/height, kChatPicThumbMaxWidth/width);
                
                
                NSInteger tw = (NSInteger) (width * scale + 1);
                NSInteger th = (NSInteger) (height * scale + 1);
                [msg addInteger:tw forKey:kIMAMSG_Image_ThumbWidth];
                [msg addInteger:th forKey:kIMAMSG_Image_ThumbHeight];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *nsTmpDir = NSTemporaryDirectory();
                NSString *imageThumbPath = [NSString stringWithFormat:@"%@/image_%@_ThumbImage", nsTmpDir, timImage.uuid];
                BOOL isDirectory = NO;
                
                if ([fileManager fileExistsAtPath:imageThumbPath isDirectory:&isDirectory]  && isDirectory == NO)
                {
                    // 本地存在
                    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageThumbPath];
                    [msg addString:imageThumbPath forKey:kIMAMSG_Image_ThumbPath];
                    return image;
                    
                }
                
                
                break;
            }
        }
    }
    
    return nil;
}

@end


@implementation TIMFileElem (ShowDescription)



@end

@implementation TIMSoundElem (ShowDescription)

@end


@implementation TIMFaceElem (ShowDescription)


@end


@implementation TIMLocationElem (ShowDescription)


@end


@implementation TIMGroupTipsElem (ShowDescription)

@end


@implementation TIMUGCElem (ShowDescription)

// 显示描述
- (NSString *)showDescriptionOf:(TSIMMsg *)msg
{
    // 后面转成对应的描述信息
    return @"[视频]";
}

@end


@implementation TIMCustomElem (ShowDescription)

// 目前聊天界面用的时间戮是用TIMCustomElem
// 将要显示的时间转成Data
- (void)setFollowTime:(NSDate *)date
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:date];
    self.data = data;
}

- (NSDate *)getFollowTime
{
    NSDate *date = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    return date;
}

// 显示的时间戮
- (NSString *)timeTip {
    NSDate *date = [self getFollowTime];
    return [date timeTextOfDate];
}

- (NSString *)revokedTip {
    return @"消息已被撤回";
}

@end
