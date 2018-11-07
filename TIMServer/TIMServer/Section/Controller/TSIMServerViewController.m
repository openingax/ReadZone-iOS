//
//  TSIMServerViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMServerViewController.h"
#import "TSConfig.h"
#import <ImSDK/ImSDK.h>
#import "TSAPITencent.h"
#import "TSUserManager.h"
#import "UIView+Toast.h"
#import "TSConversationManager.h"
#import "TSIMMsg.h"

@interface TSIMServerViewController ()
<
TIMConnListener,
TIMUserStatusListener,
TIMRefreshListener,
TIMFriendshipListener,
TIMGroupListener,
TIMMessageListener
>

@property(nonatomic,assign) BOOL hasLogin;
@property(nonatomic,strong) TSConversationManager *convManager;

@end

@implementation TSIMServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentMsgs = [NSMutableArray array];
    
    [self configTIMAccount];
    
//    self.convManager = [[TSConversationManager alloc] init];
    [[TIMManager sharedInstance] addMessageListener:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_hasLogin) {
        [self loginTIM];
    }
    
    
}

- (void)configTIMAccount {
    TIMManager *manager = [TIMManager sharedInstance];

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
    //    userConfig.messgeRevokeListener = self.conversationMgr;
    userConfig.friendshipListener = self;//关系链数据本地缓存监听器（加载好友扩展包、enableFriendshipProxy有效）
    userConfig.groupListener = self;//群组据本地缓存监听器（加载群组扩展包、enableGroupAssistant有效）

    int setConfigStatus = [manager setUserConfig:userConfig];
    NSLog(@"setConfigStatus: %d", setConfigStatus);
}

- (void)loginTIM {
    
//    TSAPITencent *apiManager = [[TSAPITencent alloc] init];
//    [apiManager fetchSigWith:[TSUserManager shareInstance].account complete:^(BOOL isSuccess, NSString * _Nonnull sig) {
//
//    }];
    
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.identifier = [NSString stringWithFormat:@"%@", [TSUserManager shareInstance].account];
    
    param.userSig = [TSUserManager shareInstance].userSig;
    
    param.appidAt3rd = kTimIMSdkAppId;
    
    [[TIMManager sharedInstance] login:param succ:^{
        
        self.hasLogin = YES;
        [self registNotification];
        [self.view makeToast:@"登录成功"];
        if ([self respondsToSelector:@selector(didLogin)]) {
            [self didLogin];
        }
        
    } fail:^(int code, NSString *msg) {
        
        [self.view makeToast:[@"登录失败\n" stringByAppendingString:msg]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

// 子类继承这个方法，以接收 IM 服务登录成功的通知
- (void)didLogin {
    
}

- (void)registNotification {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)onNewMessage:(NSArray *)msgs {
    for (TIMMessage *msg in msgs) {
        TSIMMsg *imMsg = [TSIMMsg msgWithMsg:msg];
        if ([imMsg isSystemMsg] || [imMsg type] == TSIMMsgTypeUnknow) {
            return;
        }
        NSString *tip = [imMsg msgTip];
        [self.currentMsgs addObject:tip];
    }
    
    [self didReceiveNewMsg];
}

- (void)didReceiveNewMsg {
    
}

@end
