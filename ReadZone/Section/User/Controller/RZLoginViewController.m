//
//  RZRootViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

// Vendor
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

// View
#import "RZUserTextField.h"
#import "RZUserButton.h"

// Controller
#import "RZLoginViewController.h"
#import "RZRegisterViewController.h"


static CGFloat marginHorizon = 24;

@interface RZLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) RZUserTextField *accountTF;
@property (nonatomic, strong) RZUserTextField *passwordTF;
@property (nonatomic, strong) RZUserButton *loginBtn;

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation RZLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    
    self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.100:8000/"]];
    self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self drawView];
    
    // 注册键盘收起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillHide:(NSNotification *)noti {
//    self.accountLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
//    self.passwordLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
}

- (void)drawView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = RZLocalizedString(@"LOGIN_LABEL_TITLE", @"登录页的大标题【登录】");
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightLight];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(self.view).with.offset(40+kNavTotalHeight);
    }];
    
    self.accountTF = [[RZUserTextField alloc] initWithType:RZUserTextFieldTypeAccount];
    [self.accountTF addTarget:self action:@selector(accountValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(30);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    self.passwordTF = [[RZUserTextField alloc] initWithType:RZUserTextFieldTypePassword];
    [self.passwordTF addTarget:self action:@selector(passwordValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(self.accountTF.mas_bottom).with.offset(30);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    self.loginBtn = [[RZUserButton alloc] initWithTitle:RZLocalizedString(@"LOGIN_BTN_LOGIN", @"登录页登录按钮的标题【登录】") titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithHex:kColorUserBtnBg] onPressBlock:^{
        [self loginAction];
    }];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
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
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-30);
        make.centerX.equalTo(self.view);
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
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    NSDictionary *params = @{
                             @"account": account,
                             @"password": password
                             };
    [self.httpManager POST:@"users/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.view makeToast:@"登录成功" duration:1.5 position:CSToastPositionBottom];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"登录失败，请重试" duration:1.5 position:CSToastPositionBottom];
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
- (AFHTTPSessionManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.100:8000/"]];
    }
    return _httpManager;
}

@end
