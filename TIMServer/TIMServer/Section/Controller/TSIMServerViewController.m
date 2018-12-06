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
@property(nonatomic,strong) TSAPIUser *userAPI;

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
    [[TIMManager sharedInstance] doForeground:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self didLogin];
}

- (void)dealloc {
    [_loginParam saveToLocal];
}

// 退出留言板，做一些退出的操作
- (void)didTIMServerExit {
    //    [self.inputView endEditing:YES];
    
    [[TIMManager sharedInstance] removeMessageListener:[TSIMAPlatform sharedInstance].conversationMgr];
    [[TSIMAPlatform sharedInstance] saveToLocal];
    
    [[[TSIMAPlatform sharedInstance].conversationMgr conversationList] removeAllObjects];
    [[TSIMAPlatform sharedInstance].conversationMgr asyncConversationList];
    
    TIMBackgroundParam *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:0];
    [[TIMManager sharedInstance] doBackground:param succ:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

#pragma mark - Login

//- (void)loginNotiFromRN {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    //    BOOL isAutoLogin = [TSIMAPlatform isAutoLogin];
//    //    if (isAutoLogin) {
//    //        _loginParam = [IMALoginParam loadFromLocal];
//    //    } else {
//    _loginParam = [[IMALoginParam alloc] init];
//    //    }
//
//    //    if (isAutoLogin && [_loginParam isVailed]) {
//    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //            [self autoLogin];
//    //        });
//    //    } else {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self loginTIM];
//    });
//    //    }
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTIMServerExit) name:kTIMServerExitNoti object:nil];
//
//    // 模拟 App 进入前台的动作
//    [[TIMManager sharedInstance] doForeground:^{
//
//    } fail:^(int code, NSString *msg) {
//
//    }];
//}

//- (void)login {
//    TIMLoginParam *param = [[TIMLoginParam alloc] init];
//    param.identifier = [NSString stringWithFormat:@"%@", [TSUserManager shareInstance].account];
//
//    param.userSig = [TSUserManager shareInstance].userSig;
//
//    param.appidAt3rd = kTimIMSdkAppId;
//
//    @weakify(self);
//    [[TSIMAPlatform sharedInstance] login:param succ:^{
//        @strongify(self);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        self.hasLogin = YES;
//
//        if ([self respondsToSelector:@selector(didLogin)]) {
//            [self didLogin];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent object:nil userInfo:@{@"status": @(YES), @"msg": @""}];
//
//    } fail:^(int code, NSString *msg) {
//
//        @strongify(self)/
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//        if (code == 70013) {
//            [[TSUserManager shareInstance] deleteUserSig];
//            [self loginNotiFromRN];
//        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kTIMLoginSuccEvent object:nil userInfo:@{@"status": @(NO), @"msg": [NSString stringWithFormat:@"code: %d  msg: %@", code, msg]}];
//            [TSAlertManager showMessage:[NSString stringWithFormat:@"留言板登录失败\n%d: %@", code, msg]];
//
//            @weakify(self);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                @strongify(self);
//
//                [self dismissViewControllerAnimated:YES completion:nil];
//            });
//        }
//    }];
//}

// 子类继承这个方法，以接收 IM 服务登录成功的通知
- (void)didLogin {
    
}

#pragma mark - 刷新票据代理

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _userInfo = userInfo;
//    [self loginTIM];
}


- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _loginParam.tokenTime = 0;
//    [self loginTIM];
}


- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self OnRefreshTicketFail:errInfo];
}

@end
