//
//  TSManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * kTIMLoginSuccEvent = @"kTIMLoginSuccEvent";
static NSString * kTIMNewMsgEvent = @"kTIMNewMsgEvent";

@interface TSManager : NSObject

/**
 显示留言板视图控制器

 @param deviceID 设备 did
 @param controller 宿主控制器
 */
- (void)showMsgVCWithAccount:(NSString *)account
                    nickName:(NSString *)nickName
                     faceURL:(NSString *)faceURL
                    deviceID:(NSString *)deviceID
                  controller:(UIViewController *)controller;
- (void)loginTIM;
- (void)logoutTIM;

@end
