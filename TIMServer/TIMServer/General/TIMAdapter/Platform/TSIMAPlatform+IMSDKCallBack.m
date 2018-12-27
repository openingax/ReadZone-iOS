//
//  TSIMAPlatform+IMSDKCallBack.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/26.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMAPlatform+IMSDKCallBack.h"
#import "TSConversationManager.h"

@implementation TSIMAPlatform (IMSDKCallBack)


#pragma mark - TIMConnListener

/**
 *  网络连接成功
 */
- (void)onConnSucc
{
    self.isConnected = YES;

    TCQALNetwork net = [[QalSDKProxy sharedInstance] getNetType];
    [self changeToNetwork:net];
    NSString *qalVersion = [[QalSDKProxy sharedInstance] getSDKVer];
    [self.conversationMgr onConnect];
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err
{

    self.isConnected = NO;
    [self.conversationMgr onDisConnect];

    DebugLog(@"网络连接失败");
}

/**
 *  网络连接断开
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err
{

    self.isConnected = NO;
    [self.conversationMgr onDisConnect];

    DebugLog(@"网络连接断开 code = %d, err = %@", code, err);
}


/**
 *  连接中
 */
- (void)onConnecting
{
    DebugLog(@"连接中");
}

- (void)registNotification
{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


#pragma mark - TIMUserStatusListener

// 被踢下线了
- (void)onForceOffline {
    
    DebugLog(@"踢下线通知");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TIMLoginSuccNotification object:@{TIMLoginSuccStatusUserInfoKey : @(NO)}];
    
    void (^logoutBlock)(int code, NSString *msg) = ^(int code, NSString *msg) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TIMKickedOfflineNotification
                                                            object:nil
                                                          userInfo:@{TIMKickedOfflineCodeUserInfoKey : @(code),
                                                                     TIMKickedOfflineMessageUserInfoKey: msg}
         ];
    };
    
    [self logout:^{
        logoutBlock(0, @"退出成功");
    } fail:^(int code, NSString *msg) {
        logoutBlock(code, msg);
    }];
}

- (void)onRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMgr asyncConversationList];
        [[TIMManager sharedInstance] addMessageListener:self.conversationMgr];
    });
}

- (void)onRefreshConversations:(NSArray *)conversations {
    [self.conversationMgr asyncConversationList];
}

- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo {
    
}

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo {
    
}

- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo {
    
}

@end
