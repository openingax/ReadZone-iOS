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

#import "RZUserInfoModel.h"

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
    
    AVUser *newUser = [AVUser user];
    newUser.username = account;
    newUser.password = password;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self.view makeToast:@"注册成功" duration:1.5 position:CSToastPositionBottom];
            
            // 注册成功后，设置用户一些默认数据
            [RZUserInfoModel registerSubclass];
            RZUserInfoModel *infoModel = [[RZUserInfoModel alloc] init];
            infoModel.user = [AVUser currentUser];
            infoModel.userName = [self randomUserName];
            infoModel.account = self.accountTF.text;
            infoModel.userAvatar = kScreenScale == 3 ? @"http://lc-2qf4yfo6.cn-n1.lcfile.com/acee5012ef59ba1736aa.png" : @"http://lc-2qf4yfo6.cn-n1.lcfile.com/0f3c61f2aa0c840bb83e.png";
            infoModel.gender = 0;
            infoModel.phoneModel = [RZBaseUtils iPhoneType];
            infoModel.screenScale = kScreenScale;
            [infoModel saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"%@", error] duration:3.5 position:CSToastPositionBottom];
        }
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

#pragma mark - Private
-(NSString *)randomUserName{
    NSArray *name_array = @[@"沈",@"秦",@"云",@"唐",@"高",@"裴",@"萧",@"上官",@"慕容",@"司徒",@"南宫",@"百里",@"北宫",@"月",@"楚",@"言",@"琴",@"古",@"镜",@"龙",@"冷",@"叶",@"北冥",@"公孙",@"独孤",@"皇甫",@"尚",@"闻人",@"苍羽",@"轩辕",@"南风",@"即墨"];
    NSArray *secondname_array = @[@"浩",@"凌风",@"绝尘",@"文昭",@"阳城",@"文",@"奇",@"华晨",@"鹤城",@"袁也",@"成飞",@"哲七",@"鸿远",@"正",@"心池",@"池",@"心",@"阅",@"光",@"水",@"翰",@"和",@"清",@"易",@"宣",@"德",@"茂",@"明",@"纬",@"寺",@"明",@"晖",@"飞语",@"文哲",@"真",@"嘉",@"一",@"",@"寒",@"亦凌",@"宇",@"莫离",@"陵",@"宇轩",@"晨浩",@"痕",@"渊",@"尚城",@"离",@"陌",@"渡",@"陌然"];
    int name_value = arc4random()%name_array.count;
    int secondname_value = arc4random()%secondname_array.count;
    
    NSString *name_str = name_array[name_value];
    NSString *secondname_str = secondname_array[secondname_value];
    
    return [NSString stringWithFormat:@"%@%@", name_str, secondname_str];
}

@end
