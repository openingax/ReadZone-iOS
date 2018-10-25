//
//  RZMsgViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/24.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZMsgViewController.h"
#import <ImSDK/ImSDK.h>

@interface RZMsgViewController ()
<
TIMConnListener,
TIMUserStatusListener,
TIMRefreshListener,
TIMFriendshipListener,
TIMGroupListener
>

@property(nonatomic,strong) UILabel *msgLabel;
@property(nonatomic,strong) UITextField *inputTF;

@end

@implementation RZMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.identifier = @"86-18814098638";
    param.userSig = @"eJx1kEFPgzAYhu-8CtKzyqCllN0M22CbshHMzLwQtnZro3a17YJs8b9L0EQuftfnyfsk39VxXRc8PZR39X5-Oktb2VYx4I5dEMUBuPnDSgla1baCmvbYR6Pu-BDCgcU*ldCsqg*W6d4KwjjotIEiKJNWHMSvQPCtT0g3FhMMycAz9LXqo--XjDj28HG6TeZFclx7XjnD3mLN0x3PsnwSmUtWkMaqdNY8T9o37iflh8ZtMef3C7iSy5iRC5uitFmuAiRVnntnXCIdm5OJKLdyp-OX7WaQtOL95zt*iEYQowhB4Hw53yODV78_";
    param.appidAt3rd = kTimIMSdkAppId;
    
    @weakify(self);
    [[TIMManager sharedInstance] login:param succ:^{
        @strongify(self);
        
        [self registNotification];
        [self.view makeToast:@"登录成功"];
    } fail:^(int code, NSString *msg) {
        @strongify(self);
        [self.view makeToast:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - DrawView

- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"MESSAGE_NAV_TITLE", @"消息根页面导航栏标题【消息】");
}

- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Notification

- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

@end
