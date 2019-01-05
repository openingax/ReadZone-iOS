//
//  TSManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// TIM server login succ or fail noti.
UIKIT_EXTERN NSNotificationName const TIMLoginSuccNotification;
// TIM server new msg noti.
UIKIT_EXTERN NSNotificationName const TIMNewMsgNotification;

// NSNumber of BOOL, YES mean login succ, No mean login fail.
UIKIT_EXTERN NSString *const TIMLoginSuccStatusUserInfoKey;
// NSString Value, login succ with an empty string, fail with message you need.
UIKIT_EXTERN NSString *const TIMLoginSuccMessageUserInfoKey;
// NSString Value, YES mean has new msg, NO is used to noti you clear new msg status.
UIKIT_EXTERN NSString *const TIMNewMsgStatusUserInfoKey;

@interface TSManager : NSObject


/**
 登录 TIM 留言板服务

 @param account 用户账号
 @param nickName 用户呢称
 @param faceURL 用户头像
 @param deviceID 当前冰箱设备 did
 */
- (void)loginTIMWithAccount:(NSString *)account
                   nickName:(NSString *)nickName
                    faceURL:(NSString *)faceURL
                   deviceID:(NSString *)deviceID;


/**
 显示 TIM 留言板

 @param controller 用户弹出留言板的 VC
 */
- (void)showTIMWithController:(UIViewController *)controller;


/**
 退出留言板
 
 @discuss 当退出 RN 插件控制器时，再调 logoutTIM 方法退出留言板
 在 RN 插件控制器里，添加 hasShowTIM 变量去记录是否显示了留言板，并在 viewWillDisappear: 方法里判断这个变量，以决定是否退出留言板
 */
- (void)logoutTIM;

@end
