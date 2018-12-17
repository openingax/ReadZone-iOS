//
//  TSIMAPlatform.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QALSDK/QalSDKProxy.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
#import "TSConversationManager.h"
#import "IMAPlatformConfig.h"
#import "TSConfig.h"
#import "TSIMManager.h"
#import "TSIMHost.h"

//#import "IMAContactManager.h"

// TIMServer IM 服务的业务逻辑入口，
typedef EQALNetworkType TCQALNetwork;

@interface TSIMAPlatform : NSObject
{
@protected
    TSIMHost                     *_host;             // 当前用户
//    IMAContactManager           *_contactMgr;       // 联系人
    TSConversationManager        *_conversationMgr;  // 会话列表
}

@property(nonatomic,readonly) TSIMHost *host;
@property(nonatomic,readonly) TSConversationManager *conversationMgr;
@property(nonatomic,assign) BOOL isConnected;
//

+ (instancetype)config;

+ (instancetype)sharedInstance;


// 是否是自动登录
+ (BOOL)isAutoLogin;

+ (void)setAutoLogin:(BOOL)autologin;

- (IMAPlatformConfig *)localConfig;

- (void)saveToLocal;

// 被踢下线后，再重新登录
- (void)offlineLogin;
- (void)logout:(TIMLoginSucc)succ fail:(TIMFail)fail;

- (void)configHost:(TIMLoginParam *)param;

- (void)changeToNetwork:(TCQALNetwork)work;

@end
