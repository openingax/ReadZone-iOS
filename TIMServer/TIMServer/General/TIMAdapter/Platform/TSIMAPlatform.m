//
//  TSIMAPlatform.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMAPlatform.h"
#import "TSIMAPlatform+IMSDKCallBack.h"

@implementation TSIMAPlatform

static TSIMAPlatform *_sharedInstance = nil;

+ (instancetype)config {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TSIMAPlatform alloc] init];
        [_sharedInstance configIMSDK];
    });
    return _sharedInstance;
}

+ (instancetype)sharedInstance {
    return _sharedInstance;
}

- (TSConversationManager *)conversationMgr {
    if (!_conversationMgr) {
        _conversationMgr = [[TSConversationManager alloc] init];
    }
    return _conversationMgr;
}

- (void)configIMSDK
{
    TIMManager *manager = [TIMManager sharedInstance];
    
    // 默认正式环境
    [manager setEnv:0];
    
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [kTimIMSdkAppId intValue];
    config.accountType = kTimIMSdkAccountType;
    config.disableCrashReport = NO;
    config.disableLogPrint = NO;
    config.connListener = self;
    [manager initSdk:config];
    
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    //    userConfig.disableStorage = YES;//禁用本地存储（加载消息扩展包有效）
    //    userConfig.disableAutoReport = YES;//禁止自动上报（加载消息扩展包有效）
    //    userConfig.enableReadReceipt = YES;//开启C2C已读回执（加载消息扩展包有效）
    userConfig.disableRecnetContact = NO;//不开启最近联系人（加载消息扩展包有效）
    userConfig.disableRecentContactNotify = YES;//不通过onNewMessage:抛出最新联系人的最后一条消息（加载消息扩展包有效）
    userConfig.enableFriendshipProxy = YES;//开启关系链数据本地缓存功能（加载好友扩展包有效）
    userConfig.enableGroupAssistant = YES;//开启群组数据本地缓存功能（加载群组扩展包有效）
    TIMGroupInfoOption *giOption = [[TIMGroupInfoOption alloc] init];
    giOption.groupFlags = 0xffffff;//需要获取的群组信息标志（TIMGetGroupBaseInfoFlag）,默认为0xffffff
    giOption.groupCustom = nil;//需要获取群组资料的自定义信息（NSString*）列表
    userConfig.groupInfoOpt = giOption;//设置默认拉取的群组资料
    TIMGroupMemberInfoOption *gmiOption = [[TIMGroupMemberInfoOption alloc] init];
    gmiOption.memberFlags = 0xffffff;//需要获取的群成员标志（TIMGetGroupMemInfoFlag）,默认为0xffffff
    gmiOption.memberCustom = nil;//需要获取群成员资料的自定义信息（NSString*）列表
    userConfig.groupMemberInfoOpt = gmiOption;//设置默认拉取的群成员资料
    TIMFriendProfileOption *fpOption = [[TIMFriendProfileOption alloc] init];
    fpOption.friendFlags = 0xffffff;//需要获取的好友信息标志（TIMProfileFlag）,默认为0xffffff
    fpOption.friendCustom = nil;//需要获取的好友自定义信息（NSString*）列表
    fpOption.userCustom = nil;//需要获取的用户自定义信息（NSString*）列表
    userConfig.friendProfileOpt = fpOption;//设置默认拉取的好友资料
    userConfig.userStatusListener = self;//用户登录状态监听器
    userConfig.refreshListener = self;//会话刷新监听器（未读计数、已读同步）（加载消息扩展包有效）
    //    userConfig.receiptListener = self;//消息已读回执监听器（加载消息扩展包有效）
    //    userConfig.messageUpdateListener = self;//消息svr重写监听器（加载消息扩展包有效）
    //    userConfig.uploadProgressListener = self;//文件上传进度监听器
    //    userConfig.groupEventListener todo
//    [[TIMManager sharedInstance] addMessageListener:self.conversationMgr];
    userConfig.messgeRevokeListener = self.conversationMgr;
    userConfig.friendshipListener = self;//关系链数据本地缓存监听器（加载好友扩展包、enableFriendshipProxy有效）
    userConfig.groupListener = self;//群组据本地缓存监听器（加载群组扩展包、enableGroupAssistant有效）
    [manager setUserConfig:userConfig];
}

#pragma mark - 登录

#define kIMAPlatform_AutoLogin_Key @"kIMAPlatform_AutoLogin_Key"

// 是否是自动登录
+ (BOOL)isAutoLogin {
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kIMAPlatform_AutoLogin_Key];
    return [num boolValue];
}

+ (void)setAutoLogin:(BOOL)autologin {
    [[NSUserDefaults standardUserDefaults] setObject:@(autologin) forKey:kIMAPlatform_AutoLogin_Key];
}

- (IMAPlatformConfig *)localConfig {
    return nil;
}

- (void)saveToLocal {
    
}

- (void)offlineLogin
{
    // 被踢下线，则清空单例中的数据，再登录后再重新创建
    [self saveToLocal];
    
//    _contactMgr = nil;
    
    [[TIMManager sharedInstance] removeMessageListener:_conversationMgr];
    _conversationMgr = nil;
}

- (void)logout:(TIMLoginSucc)succ fail:(TIMFail)fail
{
    __weak TSIMAPlatform *ws = self;
    
    [[TIMManager sharedInstance] logout:^{
        [ws onLogoutCompletion];
        if (succ)
        {
            succ();
        }
    } fail:^(int code, NSString *err) {
        [ws onLogoutCompletion];
        if (fail)
        {
            fail(code, err);
        }
    }];
}

- (void)onLogoutCompletion
{
    [self offlineLogin];
    
    [TSIMAPlatform setAutoLogin:NO];
    _host = nil;
}

- (void)changeToNetwork:(TCQALNetwork)work
{
//    if (work > EQALNetworkType_ReachableViaWWAN)
//    {
//        // 不处理这些
//        work = EQALNetworkType_ReachableViaWWAN;
//    }
//    DebugLog(@"网络切换到(-1:未知 0:无网 1:wifi 2:移动网):%d", work);
//    //    if (work != _networkType)
//    //    {
//    self.networkType = work;
//    
//    //    }
}



@end
