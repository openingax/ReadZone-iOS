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

// Manager
#import "TIMServerHelper.h"

@interface TSIMServerViewController ()
<TIMConnListener,
TIMUserStatusListener,
TIMRefreshListener,
TIMUploadProgressListener,
TIMFriendshipListener,
TIMGroupListener
>

@property(nonatomic,assign) BOOL hasInitSDK;
@property(nonatomic,assign) BOOL hasLogin;

@end

@implementation TSIMServerViewController

- (instancetype)init {
    if (self = [super init]) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(globalQueue, ^{
            [self configTIMAccount];
        });
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_hasLogin && _hasInitSDK) {
        // 延时 1 秒登录，否则失败率很高
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginTIM];
        });
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
    userConfig.uploadProgressListener = self;//文件上传进度监听器
    //        userConfig.groupEventListener todo
    //    userConfig.messgeRevokeListener = self.conversationMgr;
    userConfig.friendshipListener = self;//关系链数据本地缓存监听器（加载好友扩展包、enableFriendshipProxy有效）
    userConfig.groupListener = self;//群组据本地缓存监听器（加载群组扩展包、enableGroupAssistant有效）
    
    int setConfigStatus = [manager setUserConfig:userConfig];
    NSLog(@"setConfigStatus: %d", setConfigStatus);
    
    self.hasInitSDK = (BOOL)!setConfigStatus;
}

- (void)loginTIM {
    
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.identifier = [NSString stringWithFormat:@"%@", [TSUserManager shareInstance].account];
    
    param.userSig = [TSUserManager shareInstance].userSig;
    
    param.appidAt3rd = kTimIMSdkAppId;
    
    [[TIMManager sharedInstance] login:param succ:^{
        
        self.hasLogin = YES;
        [self.view makeToast:@"登录成功"];
        if ([self respondsToSelector:@selector(didLogin)]) {
            [self didLogin];
        }
        
    } fail:^(int code, NSString *msg) {
        
        if (code == 6023) {
            // 被踢下线
            [self showKickedAlert];
            
        } else if (code == 6013) {
            [self configTIMAccount];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginTIM];
            });
        } else {
            [TSAlertManager showMessage:[NSString stringWithFormat:@"code: %d\n登录失败\n%@", code, msg]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

// 子类继承这个方法，以接收 IM 服务登录成功的通知
- (void)didLogin {
    
}

// 显示被踢下线的警告弹窗
- (void)showKickedAlert {
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:TIMLocalizedString(@"ALERT_BTN_LOGOUT", @"警告弹窗取消按钮") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:TIMLocalizedString(@"ALERT_BTN_RELOGIN", @"警告弹窗重新登录按钮") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self loginTIM];
    }];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TIMLocalizedString(@"ALERT_MSG_KICKED_TITLE", @"被踢下线的标题") message:TIMLocalizedString(@"ALERT_MSG_KICKED_MSG", @"被踢下线的消息详情") preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:action0];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
