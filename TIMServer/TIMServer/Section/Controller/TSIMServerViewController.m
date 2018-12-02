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
#import "IMALoginParam.h"
#import "TSIMAPlatform.h"
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

@end

@implementation TSIMServerViewController

#define kIMAAutoLoginParam @"kIMAAutoLoginParam"

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isAutoLogin = [TSIMAPlatform isAutoLogin];
    if (isAutoLogin) {
        _loginParam = [IMALoginParam loadFromLocal];
    } else {
        _loginParam = [[IMALoginParam alloc] init];
    }
    
    if (isAutoLogin && [_loginParam isVailed]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self autoLogin];
        });
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginTIM];
        });
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTIMServerExit) name:kTIMServerExitNoti object:nil];
    
    // 模拟 App 进入前台的动作
    [[TIMManager sharedInstance] doForeground:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (!_hasLogin) {
//        // 延时 1 秒登录，否则失败率很高
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self loginTIM];
//        });
//    }
}

- (void)dealloc {
    [_loginParam saveToLocal];
}

// 退出留言板，做一些退出的操作
- (void)didTIMServerExit {
    //    [self.inputView endEditing:YES];
    
    [[TSIMAPlatform sharedInstance] saveToLocal];
    
    TIMBackgroundParam *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:0];
    [[TIMManager sharedInstance] doBackground:param succ:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

#pragma mark - Login

- (void)autoLogin {
    if ([_loginParam isExpired]) {
        // 刷新票据
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TLSHelper getInstance] TLSRefreshTicket:_loginParam.identifier andTLSRefreshTicketListener:self];
    } else {
        [self loginTIM];
    }
}

- (void)loginIMSDK {
    
}

- (void)loginTIM {
    
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.identifier = [NSString stringWithFormat:@"%@", [TSUserManager shareInstance].account];
    
    param.userSig = [TSUserManager shareInstance].userSig;
    
    param.appidAt3rd = kTimIMSdkAppId;
    
    [[TSIMAPlatform sharedInstance] login:param succ:^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.hasLogin = YES;
        
        if ([self respondsToSelector:@selector(didLogin)]) {
            [self didLogin];
        }
        
    } fail:^(int code, NSString *msg) {
        [TSAlertManager showMessage:[NSString stringWithFormat:@"留言板登录失败\n%d: %@", code, msg]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

// 子类继承这个方法，以接收 IM 服务登录成功的通知
- (void)didLogin {
    
}

#pragma mark - 刷新票据代理

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _userInfo = userInfo;
    [self loginTIM];
}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    _loginParam.tokenTime = 0;
    [self loginTIM];
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [self OnRefreshTicketFail:errInfo];
}

@end
