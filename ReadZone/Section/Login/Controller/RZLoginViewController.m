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

// Model
#import "RZUserInfoModel.h"

// Manager
#import "RZAPIUser.h"
#import "AppDelegate.h"
#import "RZUserManager.h"
#import "RZAPITencent.h"

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

@property(nonatomic,strong) RZAPIUser *userAPI;
@property(nonatomic,strong) RZAPITencent *timAPI;

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
- (void)drawNavBar {
    [super drawNavBar];
    self.navBar.hidenBackItem = YES;
}
- (void)drawView {
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    
    self.animatedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action
- (void)accountValueChange:(RZUserTextField *)textField {
    if (![NSString isEmptyString:textField.text] && ![NSString isEmptyString:self.passwordTF.text]) {
        self.loginBtn.enable = YES;
    } else {
        self.loginBtn.enable = NO;
    }
}

- (void)passwordValueChange:(RZUserTextField *)textField {
    if (![NSString isEmptyString:textField.text] && ![NSString isEmptyString:self.accountTF.text]) {
        self.loginBtn.enable = YES;
    } else {
        self.loginBtn.enable = NO;
    }
}

- (void)loginAction {
    [self.view endEditing:YES];
    
    [AVUser logInWithUsernameInBackground:self.accountTF.text password:self.passwordTF.text block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if (user && !error) {
            
            [self.timAPI fetchSigWithAccount:[NSString stringByCuttingEdgeWhiteSpaceAndNewlineCharacterSet:self.accountTF.text] complete:^(BOOL isSuccess, NSString *sig) {
                if (isSuccess) {
                    // 登录成功后，用当前用户的 objectId 查询 UserInfoModel 类的值
                    [self.userAPI fetchUserInfoWithBlock:^(RZUserModel *userInfo, NSError *error) {
                        if (!error) {
                            [RZUser shared].userInfo = userInfo;
                            
                            [[RZUserManager shareInstance] saveUserAccout:self.accountTF.text password:self.passwordTF.text sig:sig];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:userInfo];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else {
                            [[RZUserManager shareInstance] logout];
                            [self.view makeToast:@"查询不到用户信息" duration:1.5 position:CSToastPositionBottom];
                        }
                    }];
                } else {
                    // 获取 sig 失败
                    [[RZUserManager shareInstance] logout];
                    [self.animatedView makeToast:[NSString stringWithFormat:@"获取 sig 失败：%@", error] duration:2.5 position:CSToastPositionBottom];
                }
            }];
            
            
        } else {
            // 登录失败
            [self.animatedView makeToast:[NSString stringWithFormat:@"AVUser 登录失败：%@", error] duration:2.5 position:CSToastPositionBottom];
        }
    }];
}

- (void)registerAction {
    //    RZLoginViewController_Swift *loginVC_Swift = [[RZLoginViewController_Swift alloc] init];
    //    RZRegisterViewController_Swift *registerVC = [[RZRegisterViewController_Swift alloc] init];
    //    [self.navigationController pushViewController:registerVC animated:YES];
    RZRegisterViewController *registerVC = [[RZRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    //    [loginVC_Swift swiftMethodTest];
}

- (void)tapAction {
    [self.view endEditing:YES];
}

#pragma mark - Setter & Getter
- (RZAPIUser *)userAPI {
    if (!_userAPI) {
        _userAPI = [[RZAPIUser alloc] init];
    }
    return _userAPI;
}

- (RZAPITencent *)timAPI {
    if (!_timAPI) {
        _timAPI = [[RZAPITencent alloc] init];
    }
    return _timAPI;
}


@end
