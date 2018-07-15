//
//  RZRootViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

// Vendor
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

// Manager
#import "RZAPILogin.h"
#import "RZDTOLogin.h"

// View
#import "RZUserTextField.h"
#import "RZUserButton.h"

// Controller
#import "RZLoginViewController.h"
#import "RZRegisterViewController.h"
#import "RZBaseNavigationController.h"
#import "RZRootViewController.h"


static CGFloat marginHorizon = 24;

@interface RZLoginViewController () <UITextFieldDelegate>

@property(nonatomic,strong) UIView *animatedView;               // 做动画的容器视图
@property(nonatomic,strong) RZUserTextField *accountTF;
@property(nonatomic,strong) RZUserTextField *passwordTF;
@property(nonatomic,strong) RZUserButton *loginBtn;

@property(nonatomic,strong) RZAPILogin *apiManager;

@end

@implementation RZLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 这里处理页面的弹出动画
    if (self.isAnimatedShow) {
        
    } else {
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - DrawView
- (void)drawView {
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    
    self.animatedView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.animatedView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.animatedView addGestureRecognizer:tap];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = RZLocalizedString(@"LOGIN_LABEL_TITLE", @"登录页的大标题【登录】");
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightLight];
    [self.animatedView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.animatedView).with.offset(marginHorizon);
        make.top.equalTo(self.animatedView).with.offset(40+kNavTotalHeight);
    }];
    
    self.accountTF = [[RZUserTextField alloc] initWithType:RZUserTextFieldTypeAccount];
    [self.accountTF addTarget:self action:@selector(accountValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.animatedView addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.animatedView).with.offset(marginHorizon);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(30);
        make.right.equalTo(self.animatedView).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    self.passwordTF = [[RZUserTextField alloc] initWithType:RZUserTextFieldTypePassword];
    [self.passwordTF addTarget:self action:@selector(passwordValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.animatedView addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.animatedView).with.offset(marginHorizon);
        make.top.equalTo(self.accountTF.mas_bottom).with.offset(30);
        make.right.equalTo(self.animatedView).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    self.loginBtn = [[RZUserButton alloc] initWithTitle:RZLocalizedString(@"LOGIN_BTN_LOGIN", @"登录页登录按钮的标题【登录】") titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithHex:kColorUserBtnBg] onPressBlock:^{
        [self loginAction];
    }];
    [self.animatedView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.animatedView).with.offset(marginHorizon);
        make.right.equalTo(self.animatedView).with.offset(-marginHorizon);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(45);
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *registerStr = RZLocalizedString(@"LOGIN_BTN_REGISTER", @"登录页未注册按钮的标题【还未注册？】");
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:registerStr];
    [attributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName,[UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.8], NSForegroundColorAttributeName, nil] range:NSMakeRange(0, registerStr.length)];
    [registerBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.animatedView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.animatedView).with.offset(-30);
        make.centerX.equalTo(self.animatedView);
    }];
}

- (void)drawNavBar {
    [super drawNavBar];
    self.navBar.hidenBackItem = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (void)accountValueChange:(RZUserTextField *)textField {
    if (![NSString checkIsEmptyOrNull:textField.text] && ![NSString checkIsEmptyOrNull:self.passwordTF.text]) {
        self.loginBtn.enable = YES;
    } else {
        self.loginBtn.enable = NO;
    }
}

- (void)passwordValueChange:(RZUserTextField *)textField {
    if (![NSString checkIsEmptyOrNull:textField.text] && ![NSString checkIsEmptyOrNull:self.accountTF.text]) {
        self.loginBtn.enable = YES;
    } else {
        self.loginBtn.enable = NO;
    }
}

- (void)loginAction {
    [self.view endEditing:YES];
    
    //    self.apiManager.account = self.accountTF.text;
    //    self.apiManager.password = self.passwordTF.text;
    //    [self.apiManager startWithCompletion:^(RZAPI *api) {
    //        RZDTOLogin *loginModel = api.response.fetchData;
    //        [self.view makeToast:loginModel.desc duration:1.5 position:CSToastPositionBottom];
    //        if (loginModel.status == 0) {
    //            // 弹出根视图时，把登陆视图缩小往下收（仿轻芒、腾讯新闻）
    //            RZRootViewController *rootVC = [[RZRootViewController alloc] init];
    //            RZBaseNavigationController *navVC = [[RZBaseNavigationController alloc] initWithRootViewController:rootVC];
    //            [self presentViewController:navVC animated:YES completion:^{
    //
    //            }];
    //        }
    //    }];
    
    
    
    [AVUser logInWithUsernameInBackground:self.accountTF.text password:self.passwordTF.text block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (user && !error) {
            [self.animatedView makeToast:@"登录成功" duration:1 position:CSToastPositionBottom];
            
            RZRootViewController *rootVC = [[RZRootViewController alloc] init];
            RZBaseNavigationController *navVC = [[RZBaseNavigationController alloc] initWithRootViewController:rootVC];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:navVC animated:YES completion:nil];
            });
        } else {
            [self.animatedView makeToast:[NSString stringWithFormat:@"%@", error] duration:3.5 position:CSToastPositionBottom];
        }
    }];
}

- (void)registerAction {
    RZRegisterViewController *registerVC = [[RZRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)tapAction {
    [self.view endEditing:YES];
}

#pragma mark - Setter & Getter
- (RZAPILogin *)apiManager {
    if (!_apiManager) {
        _apiManager = [[RZAPILogin alloc] init];
    }
    return _apiManager;
}

@end
