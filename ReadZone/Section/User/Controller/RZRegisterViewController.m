//
//  RZRegisterViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/7.
//  Copyright © 2018年 谢立颖. All rights reserved.
//


// Vendor
#import <AFNetworking/AFNetworking.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

// View
#import "RZUserTextField.h"
#import "RZUserButton.h"

// Controller
#import "RZRegisterViewController.h"

// 按钮、输入框等组件与屏幕左右边距
static CGFloat marginHorizon = 24;

@interface RZRegisterViewController ()

@property(nonatomic,strong) RZUserTextField *accountTF;
@property(nonatomic,strong) RZUserTextField *passwordTF;
@property(nonatomic,strong) RZUserButton *registerBtn;

@property(nonatomic,strong) AFHTTPSessionManager *httpManager;

@end

@implementation RZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    self.title = RZLocalizedString(@"REGISTER_NAV_TITLE", @"导航栏标题【注册】");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DrawView
- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    self.accountTF = [[RZUserTextField alloc] initWithType:RZUserTextFieldTypeAccount];
    [self.accountTF addTarget:self action:@selector(accountValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(self.view).with.offset(40+kNavTotalHeight);
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
    
    self.registerBtn = [[RZUserButton alloc] initWithTitle:RZLocalizedString(@"REGISTER_BTN_REGISTER", @"注册按钮的标题【注册】") titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithHex:kColorUserBtnBg] onPressBlock:^{
        [self registerAction];
    }];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - tapAction
- (void)accountValueChange:(RZUserTextField *)textField {
    if (![NSString checkIsEmptyOrNull:textField.text] && ![NSString checkIsEmptyOrNull:self.passwordTF.text]) {
        self.registerBtn.enable = YES;
    } else {
        self.registerBtn.enable = NO;
    }
}

- (void)passwordValueChange:(RZUserTextField *)textField {
    if (![NSString checkIsEmptyOrNull:textField.text] && ![NSString checkIsEmptyOrNull:self.accountTF.text]) {
        self.registerBtn.enable = YES;
    } else {
        self.registerBtn.enable = NO;
    }
}

- (void)registerAction {
    [self.view endEditing:YES];
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    NSDictionary *params = @{
                             @"account": account,
                             @"password": password
                             };
    [self.httpManager POST:@"users/register" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.view makeToast:@"注册成功" duration:1.5 position:CSToastPositionBottom];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.view makeToast:@"注册失败，请重试" duration:1.5 position:CSToastPositionBottom];
    }];
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
