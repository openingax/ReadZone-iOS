//
//  RZRegisterViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/7.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZRegisterViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface RZRegisterViewController ()

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation RZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    self.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - DrawView
- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    
    self.accountTF = [[UITextField alloc] init];
    self.accountTF.placeholder = @"手机/邮箱";
    self.accountTF.backgroundColor = [UIColor whiteColor];
    self.accountTF.layer.borderWidth = 0.5;
    self.accountTF.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.accountTF.layer.cornerRadius = 3;
    self.accountTF.leftView = placeholderView;
    self.accountTF.rightView = placeholderView;
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(45);
        make.top.equalTo(self.view).with.offset(30+kNavTotalHeight);
        make.right.equalTo(self.view).with.offset(-45);
        make.height.mas_equalTo(40);
    }];
    
    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.placeholder = @"密码";
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.backgroundColor = [UIColor whiteColor];
    self.passwordTF.layer.borderWidth = 0.5;
    self.passwordTF.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.passwordTF.layer.cornerRadius = 3;
    self.passwordTF.leftView = placeholderView;
    self.passwordTF.rightView = placeholderView;
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(45);
        make.top.equalTo(self.accountTF.mas_bottom).with.offset(30);
        make.right.equalTo(self.view).with.offset(-45);
        make.height.mas_equalTo(40);
    }];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.layer.backgroundColor = [UIColor colorWithRed:110/255.f green:174/255.f blue:222/255.f alpha:1].CGColor;
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.registerBtn.layer.cornerRadius = 3;
    self.registerBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.registerBtn];
    [self.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(45);
        make.right.equalTo(self.view).with.offset(-45);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - tapAction
- (void)registerAction {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    NSDictionary *params = @{
                             @"account": account,
                             @"password": password
                             };
    [self.httpManager POST:@"users/register" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
