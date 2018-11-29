//
//  TSIMAPlatform+Login.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/29.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMAPlatform+Login.h"
#import "TSDebugMarco.h"
#import "TIMServerHelper.h"
#import "TSIMManager.h"

@implementation TSIMAPlatform (Login)

//互踢下线错误码

#define kEachKickErrorCode 6208

- (void)registNotification
{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)login:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail {
    if (!param) {
        if (fail) {
            fail(-1, @"参数错误");
        }
        return;
    }
    
    __weak TSIMAPlatform *ws = self;
    [[TIMManager sharedInstance] login:param succ:^{
        
        DebugLog(@"登录成功:%@ tinyid:%llu sig:%@", param.identifier, [[IMSdkInt sharedInstance] getTinyId], param.userSig);
        [TSIMAPlatform setAutoLogin:YES];
        
        if (succ) {
            succ();
        }
        
    } fail:^(int code, NSString *msg) {
        
        DebugLog(@"TIMLogin Failed: code=%d err=%@", code, msg);
        
        if (code == kEachKickErrorCode) {
            [ws offlineKicked:param succ:succ fail:fail];
        } else {
            if (fail) {
                fail(code, msg);
            }
        }
        
    }];
}

//离线被踢
//用户离线时，在其它终端登录过，再次在本设备登录时，会提示被踢下线，需要重新登录
- (void)offlineKicked:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail {
    
    __weak typeof(self) ws = self;
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:TIMLocalizedString(@"ALERT_BTN_LOGOUT", @"警告弹窗取消按钮") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self logout:^{
            [[TSIMManager shareInstance].topViewController dismissViewControllerAnimated:YES completion:nil];
        } fail:^(int code, NSString *msg) {
            [[TSIMManager shareInstance].topViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:TIMLocalizedString(@"ALERT_BTN_RELOGIN", @"警告弹窗重新登录按钮") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self offlineLogin];
        
        [self login:param succ:^{
            [ws registNotification];
            succ ? succ() : nil;
        } fail:fail];
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TIMLocalizedString(@"ALERT_MSG_KICKED_TITLE", @"被踢下线的标题") message:TIMLocalizedString(@"ALERT_MSG_KICKED_MSG", @"被踢下线的消息详情") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:action0];
    [alertController addAction:action1];
    [[TSIMManager shareInstance].topViewController presentViewController:alertController animated:YES completion:nil];
}


@end
