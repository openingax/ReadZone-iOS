//
//  RZRootViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZLoginViewController.h"
#import "RZRegisterViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface RZLoginViewController ()

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation RZLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1];
    
    self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.100:8000/"]];
    self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.navigationController.navigationBarHidden = YES;
    
    [self drawView];
}

- (void)drawView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    
    self.accountTF = [[UITextField alloc] init];
    self.accountTF.placeholder = @"手机/邮箱/用户名";
    self.accountTF.backgroundColor = [UIColor whiteColor];
    self.accountTF.layer.borderWidth = 0.5;
    self.accountTF.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.accountTF.layer.cornerRadius = 3;
    self.accountTF.leftView = placeholderView;
    self.accountTF.rightView = placeholderView;
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(45);
        make.top.equalTo(self.view).with.offset(80);
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
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.layer.backgroundColor = [UIColor colorWithRed:110/255.f green:174/255.f blue:222/255.f alpha:1].CGColor;
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(45);
        make.right.equalTo(self.view).with.offset(-45);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"还未注册？" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    self.logTextView = [[UITextView alloc] init];
    [self.view addSubview:self.logTextView];
    [self.logTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.top.equalTo(registerBtn.mas_bottom).with.offset(40);
        make.bottom.equalTo(self.view).with.offset(-30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)loginAction {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    NSDictionary *params = @{
                             @"account": account,
                             @"password": password
                             };
    [self.httpManager POST:@"users/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.logTextView.text = [NSString stringWithFormat:@"获取成功\n\n%@", responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.logTextView.text = [NSString stringWithFormat:@"获取失败\n\n%@", error];
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
