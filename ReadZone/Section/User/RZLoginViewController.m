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
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

static CGFloat marginHorizon = 24;

@interface RZLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIView *passwordLine;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UITextView *logTextView;
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
    self.accountLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
    self.passwordLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
}

- (void)drawView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"登录";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:32 weight:UIFontWeightLight];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(self.view).with.offset(40+kNavTotalHeight);
    }];
    
    self.accountTF = [[UITextField alloc] init];
    self.accountTF.delegate = self;
    self.accountTF.tag = 111;
    self.accountTF.placeholder = @"手机 / 邮箱 / 用户名";
    self.accountTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.accountTF];
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(30);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    self.accountLine = [[UIView alloc] init];
    self.accountLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
    [self.view addSubview:self.accountLine];
    [self.accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTF.mas_bottom);
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(0.5);
    }];
    
    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.delegate = self;
    self.passwordTF.tag = 222;
    self.passwordTF.placeholder = @"密码";
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.top.equalTo(self.accountTF.mas_bottom).with.offset(30);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    self.passwordLine = [[UIView alloc] init];
    self.passwordLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
    [self.view addSubview:self.passwordLine];
    [self.passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTF.mas_bottom);
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(0.5);
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
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.top.equalTo(self.passwordTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(46);
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *registerStr = @"还未注册？";
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 111) {
        self.accountLine.backgroundColor = [UIColor blackColor];
        self.passwordLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
    }
    if (textField.tag == 222) {
        self.accountLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
        self.passwordLine.backgroundColor = [UIColor blackColor];
    }
}

#pragma mark - Action
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
//        self.logTextView.text = [NSString stringWithFormat:@"获取成功\n\n%@", responseObject];
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
