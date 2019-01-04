//
//  IDCameraPermissionsManager.m
//  VideoCameraDemo
//
//  Created by Adriaan Stellingwerff on 10/03/2014.
//  Copyright (c) 2014 Infoding. All rights reserved.
//

#import "IDPermissionsManager.h"
#import <AVFoundation/AVFoundation.h>

@interface IDPermissionsManager ()

@end

@implementation IDPermissionsManager

- (void)checkMicrophonePermissionsWithBlock:(void(^)(BOOL granted))block
{
    NSString *mediaType = AVMediaTypeAudio;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if(!granted){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Microphone Disabled" message:@"To enable sound recording with your video please go to the Settings app > Privacy > Microphone and enable access." preferredStyle:UIAlertControllerStyleAlert];
                
                __weak typeof(self) ws = self;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [ws.rootVC dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                [alert addAction:cancelAction];
                [alert addAction:confirmAction];
                [self.rootVC presentViewController:alert animated:NO completion:nil];
            });
        }
        if(block != nil)
            block(granted);
    }];
}


- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block
{
    NSString *mediaType = AVMediaTypeVideo;
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (!granted){
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Camera disabled" message:@"This app doesn't have permission to use the camera, please go to the Settings app > Privacy > Camera and enable access." preferredStyle:UIAlertControllerStyleAlert];
                
                __weak typeof(self) ws = self;
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [ws.rootVC dismissViewControllerAnimated:YES completion:nil];
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                [alert addAction:cancelAction];
                [alert addAction:confirmAction];
                [self.rootVC presentViewController:alert animated:NO completion:nil];
                
            });
        }
        if(block)
            block(granted);
    }];
}

@end
