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

- (void)showTIMWithController:(UIViewController *)controller;
- (void)loginTIMWithAccount:(NSString *)account
                   nickName:(NSString *)nickName
                    faceURL:(NSString *)faceURL
                   deviceID:(NSString *)deviceID;
- (void)clearVC;
- (void)logoutTIM;

@end
