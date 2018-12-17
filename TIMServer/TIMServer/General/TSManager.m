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
#import "TSIMAPlatform.h"
#import "TSIMManager.h"
#import "IMAPlatformConfig.h"
#import "TSIMAPlatform+Login.h"
#import <YMCommon/NSDictionary+ymc.h>
#import <libextobjc/EXTScope.h>
#import "TSAPIUser.h"
//#import <TXLiteAVSDK_Professional/TXUGCBase.h>

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
    
    TSIMUser *receiver = [[TSIMUser alloc] initWithUserInfo:profile];
    
    self.chatVC = [[TSRichChatViewController alloc] initWithUser:receiver];
    self.navVC = [[TSBaseNavigationController alloc] initWithRootViewController:self.chatVC];
    
    self.navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:self.navVC animated:YES completion:^{
        
    }];
    [TSIMManager shareInstance].navigationController = self.navVC;
    [TSIMManager shareInstance].topViewController = self.chatVC;
}

#pragma mark - 登录 & 注销

- (void)loginTIMWithAccount:(NSString *)account nickName:(NSString *)nickName faceURL:(NSString *)faceURL deviceID:(NSString *)deviceID {
    self.account = account;
    self.nickName = nickName;
    self.faceURL = faceURL;
    self.deviceID = deviceID;
    
    [TSIMAPlatform config];
    
    if ([NSString isEmpty:account]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent
                                                            object:nil
                                                          userInfo:@{
                                                                     @"status": @(NO),
                                                                     @"message": @"用户账户 account 为空，请检查"}];
        return;
    }
    if ([NSString isEmpty:deviceID]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent
                                                            object:nil
                                                          userInfo:@{
                                                                     @"status": @(NO),
                                                                     @"message": @"设备 did 为空，请检查"}];
        return;
    }
    
    [[TSUserManager shareInstance] saveAccount:account];
    [[TSUserManager shareInstance] saveDeviceID:deviceID];
    
    // 如果获取不到 userSig
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
                        [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent
                                                                            object:nil
                                                                          userInfo:@{@"status": @(NO),
                                                                                     @"message": @"获取 userSig 失败，请尝试重试登录TIM"}];
                        return;
                    }
                }];
            } else {
                NSLog(@"检查账户注册状态失败，请尝试重新登录TIM");
                [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent
                                                                    object:nil
                                                                  userInfo:@{@"status": @(NO),
                                                                             @"message": @"检查账户注册状态失败，请尝试重新登录TIM"}];
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent object:nil userInfo:@{@"status": @(YES), @"msg": @""}];
        });
        
        TIMFriendProfileOption *option = [[TIMFriendProfileOption alloc] init];
        option.friendFlags = TIM_PROFILE_FLAG_NICK | TIM_PROFILE_FLAG_FACE_URL;
        option.friendCustom = nil;
        option.userCustom = nil;
        TIMUserProfile *profile = [[TIMUserProfile alloc] init];
        profile.faceURL = self.faceURL;
        profile.nickname = self.nickName;
        
        [[TIMFriendshipManager sharedInstance] modifySelfProfile:option profile:profile succ:^{
            [[TSIMAPlatform sharedInstance] configOnLoginSucc:param];
        } fail:^(int code, NSString *msg) {
            
        }];
        
        
        
    } fail:^(int code, NSString *msg) {
        @strongify(self);
        if (code == 70013) {
            [[TSUserManager shareInstance] deleteUserSig];
            [self loginTIMWithAccount:self.account nickName:self.nickName faceURL:self.faceURL deviceID:self.deviceID];
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent object:nil userInfo:@{@"status": @(NO), @"msg": [NSString stringWithFormat:@"code: %d  msg: %@", code, msg]}];
            });
        }
    }];
}


- (void)logoutTIM {
    [[TSUserManager shareInstance] deleteUserSig];
    
    [[TSIMAPlatform sharedInstance] logout:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}



@end
