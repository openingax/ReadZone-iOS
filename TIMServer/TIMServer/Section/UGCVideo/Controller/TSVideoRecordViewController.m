//
//  TSVideoRecordViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/28.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSVideoRecordViewController.h"
#import <CoreServices/CoreServices.h>

@interface TSVideoRecordViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation TSVideoRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self isVideoRecordAvailable]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.mediaTypes = @[(NSString *)kUTTypeMovie];
    self.delegate = self;
    
    self.showsCameraControls = NO;
    [self switchCameraIsFront:NO];
    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    self.videoMaximumDuration = 60;
}

- (BOOL)isVideoRecordAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (void)switchCameraIsFront:(BOOL)front
{
    if (front) {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            
        }
    } else {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
            [self setCameraDevice:UIImagePickerControllerCameraDeviceRear];
            
        }
    }
}

@end
