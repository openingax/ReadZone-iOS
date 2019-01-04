//
//  IDCameraPermissionsManager.h
//  VideoCameraDemo
//
//  Created by Adriaan Stellingwerff on 10/03/2014.
//  Copyright (c) 2014 Infoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDPermissionsManager : NSObject

@property(nonatomic,strong) UIViewController *rootVC;

- (void)checkMicrophonePermissionsWithBlock:(void(^)(BOOL granted))block;
- (void)checkCameraAuthorizationStatusWithBlock:(void(^)(BOOL granted))block;

@end
