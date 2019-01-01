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
#import "UIView+Toast.h"
#import "TSConversationManager.h"
#import "TSIMMsg.h"
#import "TSAPIUser.h"
#import <YMCommon/NSDictionary+ymc.h>
#import <IMGroupExt/IMGroupExt.h>

// Manager
#import "TIMServerHelper.h"
#import "IMALoginParam.h"
#import "TSIMAPlatform+Login.h"

@interface TSIMServerViewController ()
<TIMConnListener,
TIMUserStatusListener,
TIMRefreshListener,
TIMUploadProgressListener,
TIMFriendshipListener,
TIMGroupListener,
TLSRefreshTicketListener
>
{
    IMALoginParam *_loginParam;
}

@property(nonatomic,assign) BOOL hasInitSDK;
@property(nonatomic,assign) BOOL hasLogin;
@property(nonatomic,strong) TLSUserInfo *userInfo;
@property(nonatomic,strong) TSAPIUser *userAPI;

@end

@implementation TSIMServerViewController


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage tim_imageWithBundleAsset:@"ym_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(didTIMServerExit)];
    self.navigationItem.leftBarButtonItem = itemleft;
    
    // 注册被踢下线的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didOnlineKickedOfflineNotification:) name:TIMKickedOfflineNotification object:nil];
    
    [[TIMManager sharedInstance] doForeground:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
    
    // Create a public group in order to test
//    [[TIMGroupManager sharedInstance] createPublicGroup:@[@"18814098638", @"13265028638"] groupName:@"viotlocaltest" succ:^(NSString *groupId) {
//        
//    } fail:^(int code, NSString *msg) {
//        
//    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:TIMRootViewWillDisappearNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self didLogin];
}

- (void)dealloc {
    [_loginParam saveToLocal];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 留言板在线状态被强制踢下线
 */
- (void)didOnlineKickedOfflineNotification:(NSNotification *)noti {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"你的账号于其它设备登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self didTIMServerExit];
    }];
    [alert addAction:confirmAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 退出留言板，做一些退出的操作
- (void)didTIMServerExit {
    
    [TSIMManager shareInstance].topViewController = nil;
    
    // 不能移除这个监听，否则在退出留言板又回到留言板时无法接收消息
//    [[TIMManager sharedInstance] removeMessageListener:[TSIMAPlatform sharedInstance].conversationMgr];
    
    [[TSIMAPlatform sharedInstance] saveToLocal];
    
    [[[TSIMAPlatform sharedInstance].conversationMgr conversationList] removeAllObjects];
    [[TSIMAPlatform sharedInstance].conversationMgr asyncConversationList];
    
    TIMBackgroundParam *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:0];
    
    __weak typeof(self) ws = self;  // 弱引用，防止循环引用
    [[TIMManager sharedInstance] doBackground:param succ:^{
        [ws dismissViewControllerAnimated:YES completion:nil];
    } fail:^(int code, NSString *msg) {
        NSLog(@"TIMManager doBackground fail: %d %@", code, msg);
        [ws dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - Login

// 子类继承这个方法，以接收 IM 服务登录成功的动作
- (void)didLogin {
    
}

#pragma mark - 刷新票据代理

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _userInfo = userInfo;
}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _loginParam.tokenTime = 0;
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self OnRefreshTicketFail:errInfo];
}

@end
