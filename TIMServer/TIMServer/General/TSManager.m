//
//  TSManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSManager.h"
#import "TSFriendListViewController.h"
#import "TSBaseNavigationController.h"
#import "TSUserManager.h"
#import "TSRichChatViewController.h"
#import "TSIMUser.h"
#import "TSIMGroup.h"
#import "TSIMAPlatform.h"
#import "TSIMManager.h"
#import "IMAPlatformConfig.h"
#import "TSIMAPlatform+Login.h"
#import <YMCommon/NSDictionary+ymc.h>
#import <libextobjc/EXTScope.h>
#import "TSAPIUser.h"

NSNotificationName const TIMLoginSuccNotification = @"TIMLoginSuccNotification";
NSNotificationName const TIMNewMsgNotification = @"TIMNewMsgNotification";

NSString *const TIMLoginSuccStatusUserInfoKey = @"tim_login_status";
NSString *const TIMLoginSuccMessageUserInfoKey = @"tim_login_message";
NSString *const TIMNewMsgStatusUserInfoKey = @"tim_new_msg_status";


@interface TSManager ()

@property(nonatomic,strong) TSAPIUser *userAPI;

@property(nonatomic,strong) TSBaseNavigationController *navVC;
@property(nonatomic,strong) TSRichChatViewController *chatVC;

@property(nonatomic,strong) NSString *account;
@property(nonatomic,strong) NSString *nickName;
@property(nonatomic,strong) NSString *faceURL;
@property(nonatomic,strong) NSString *deviceID;

@end

@implementation TSManager

- (void)showTIMWithController:(UIViewController *)controller {
    
    TIMLoginStatus status = [[TIMManager sharedInstance] getLoginStatus];
    if (status == TIM_STATUS_LOGOUT) {// 检查登录状态，如果没登录，再重新登录一次
        [self loginTIMWithAccount:self.account nickName:self.nickName faceURL:self.faceURL deviceID:self.deviceID];
    }
    
    TIMUserProfile *profile = [[TIMUserProfile alloc] init];
    profile.identifier = [TSUserManager shareInstance].deviceID;
    profile.nickname = self.nickName;
    profile.faceURL = self.faceURL;
    
    
    TSRichChatViewController *chatVC = nil;
    
    if ([profile.identifier hasPrefix:@"Viomi"]) {
        // 单聊
        TSIMUser *receiver = [[TSIMUser alloc] initWithUserInfo:profile];
        chatVC = [[TSRichChatViewController alloc] initWithUser:receiver];
    } else if ([profile.identifier hasPrefix:@"viot"] || [profile.identifier isEqualToString:@"@TGS#2CVADKTFD"]) {
        // 群聊
        TSIMGroup *receiver = [[TSIMGroup alloc] initWithUserInfo:profile];
        chatVC = [[TSRichChatViewController alloc] initWithUser:receiver];
    }
    
    TSBaseNavigationController *navVC = [[TSBaseNavigationController alloc] initWithRootViewController:chatVC];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navVC animated:YES completion:nil];
    
    // 把当前控制器保存起来，在退出留言板时需要置为 nil，否则会导致内存泄漏
    [TSIMManager shareInstance].topViewController = chatVC;
}

#pragma mark - 登录 & 注销

- (void)loginTIMWithAccount:(NSString *)account nickName:(NSString *)nickName faceURL:(NSString *)faceURL deviceID:(NSString *)deviceID {
    self.account = account;
    self.nickName = nickName;
    self.faceURL = faceURL;
    self.deviceID = deviceID;
    
    [TSIMAPlatform config];
    
    if ([NSString isEmpty:account]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     TIMLoginSuccStatusUserInfoKey: @(NO),
                                                                     TIMLoginSuccMessageUserInfoKey: @"用户账户 account 为空，请检查"}];
        return;
    }
    if ([NSString isEmpty:deviceID]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification
                                                            object:nil
                                                          userInfo:@{
                                                                     TIMLoginSuccStatusUserInfoKey: @(NO),
                                                                     TIMLoginSuccMessageUserInfoKey: @"设备 did 为空，请检查"}];
        return;
    }
    
    [[TSUserManager shareInstance] saveAccount:account];
    [[TSUserManager shareInstance] saveDeviceID:deviceID];
    
    // 如果获取不到 userSig，需请求云米后台接口重新获取
    if ([NSString isEmpty:[TSUserManager shareInstance].userSig]) {
        if (!self.userAPI) self.userAPI = [[TSAPIUser alloc] init];
        
        @weakify(self);
        void (^succBlock)(BOOL isSucc, NSString *message, NSDictionary *dict) = ^(BOOL isSucc, NSString *message, NSDictionary *dict) {
            @strongify(self);
            if (isSucc) {
                
                @weakify(self);
                [self.userAPI loginWithAccount:[TSUserManager shareInstance].account complete:^(BOOL isSuccess, NSString *message, NSDictionary *data) {
                    @strongify(self);
                    
                    if (isSuccess) {
                        NSString *userSig = [[data notNullObjectForKey:@"result"] notNullObjectForKey:@"userSign"];
                        [[TSUserManager shareInstance] saveUserSig:userSig];
                        
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
                        @weakify(self);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
                            @strongify(self);
                            [self login];
                        });
                    } else {
                        NSLog(@"获取 userSig 失败，请尝试重试登录TIM");
                        [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification
                                                                            object:nil
                                                                          userInfo:@{TIMLoginSuccStatusUserInfoKey: @(NO),
                                                                                     TIMLoginSuccMessageUserInfoKey: @"获取 userSig 失败，请尝试重试登录TIM"}];
                        return;
                    }
                }];
            } else {
                NSLog(@"检查账户注册状态失败，请尝试重新登录TIM");
                [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification
                                                                    object:nil
                                                                  userInfo:@{TIMLoginSuccStatusUserInfoKey: @(NO),
                                                                             TIMLoginSuccMessageUserInfoKey: @"检查账户注册状态失败，请尝试重新登录TIM"}];
                return;
            }
        };
        
        [self.userAPI registerWithAccount:[TSUserManager shareInstance].account
                                 userIcon:nil
                                 complete:^(BOOL isSucc, NSString *message, NSDictionary *dict)
        {
            succBlock(isSucc, message, dict);
        }];
        
    } else {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), queue, ^{
            @strongify(self);
            [self login];
        });
    }
}

- (void)login {
    
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    
    param.identifier = [NSString stringWithFormat:@"%@", [TSUserManager shareInstance].account];
    param.userSig = [TSUserManager shareInstance].userSig;
    param.appidAt3rd = kTimIMSdkAppId;
    
    @weakify(self);
    [[TSIMAPlatform sharedInstance] login:param succ:^{
        
        // 发送登录成功的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification object:nil userInfo:@{TIMLoginSuccStatusUserInfoKey: @(YES), TIMLoginSuccMessageUserInfoKey: @"登录成功"}];
        
        // 设置当前用户的个人资料
        TIMFriendProfileOption *option = [[TIMFriendProfileOption alloc] init];
        option.friendFlags = 0xffff;
        option.friendCustom = nil;
        option.userCustom = nil;
        TIMUserProfile *profile = [[TIMUserProfile alloc] init];
        profile.allowType = TIM_FRIEND_ALLOW_ANY;
        profile.faceURL = self.faceURL;
        profile.nickname = self.nickName;
        
        [[TIMFriendshipManager sharedInstance] modifySelfProfile:option profile:profile succ:^{
            [[TSIMAPlatform sharedInstance] configOnLoginSucc:param];
        } fail:^(int code, NSString *msg) {
            DebugLog(@"修改个人资料失败");
        }];
        
        
    } fail:^(int code, NSString *msg) {
        @strongify(self);
        if (code == 70013) {
            
            // 70013 为 userSig 失效，清空 userSig 后重新登录一次即可
            [[TSUserManager shareInstance] deleteUserSig];
            [self loginTIMWithAccount:self.account nickName:self.nickName faceURL:self.faceURL deviceID:self.deviceID];
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification object:nil userInfo:@{TIMLoginSuccStatusUserInfoKey: @(NO), TIMLoginSuccMessageUserInfoKey: [NSString stringWithFormat:@"code: %d  msg: %@", code, msg]}];
            });
        }
    }];
}

- (void)logoutTIM {
    
    [[TSUserManager shareInstance] deleteUserSig];
    
    [[TSIMAPlatform sharedInstance] logout:^{
        NSLog(@"TIM 退出成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"TIM 退出失败，请注意日活可能超限");
    }];
}

- (void)dealloc {
    DebugLog(@"TSManager dealloc");
}


@end
