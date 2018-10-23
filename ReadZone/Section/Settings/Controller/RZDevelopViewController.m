//
//  RZDevelopViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/23.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZDevelopViewController.h"

@interface RZDevelopViewController () <UITextFieldDelegate>

@property(nonatomic,strong) UIView *statusPoint;
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) UITextField *ipTF;
@property(nonatomic,strong) UISwitch *modeSwitch;

@end

@implementation RZDevelopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
    
    BOOL isDevelopMode = [[[NSUserDefaults standardUserDefaults] objectForKey:kWebDevelopKey] integerValue] == 1 ? YES : NO;
    NSString *ipAddr = [[NSUserDefaults standardUserDefaults] objectForKey:kWebIPAddrKey];
    
    self.statusPoint.backgroundColor = isDevelopMode ? [UIColor redColor] : [UIColor greenColor];
    self.statusLabel.text = isDevelopMode ? RZLocalizedString(@"DEVELOP_H5_DEVELOP_MODE", @"当前处于 H5 开发模式") : RZLocalizedString(@"DEVELOP_H5_RELEASE_MODE", @"当前处于 H5 正式环境");
    self.ipTF.text = [NSString isEmptyString:ipAddr] ? @"" : ipAddr;
    self.ipTF.textColor = isDevelopMode ? [UIColor blackColor] : [UIColor grayColor];
    self.modeSwitch.on = isDevelopMode;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - DrawView
- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"DEVELOP_NAV_TITLE", @"开发者中心的导航栏标题【开发者中心】");
}

- (void)drawView {
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(26 + kNavTotalHeight);
        make.centerX.equalTo(self.view);
    }];
    
    self.statusPoint = [[UIView alloc] init];
    self.statusPoint.backgroundColor = [UIColor greenColor];
    self.statusPoint.layer.cornerRadius = 3.f;
    [self.view addSubview:self.statusPoint];
    [self.statusPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusLabel.mas_left).with.offset(-6);
        make.centerY.equalTo(self.statusLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    UILabel *ipLabel = [[UILabel alloc] init];
    ipLabel.text = RZLocalizedString(@"DEVELOP_IP_LABEL", @"开发者中心 IP Label 的 Text【H5本地调试 IP】");
    ipLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    ipLabel.textColor = [UIColor blackColor];
    ipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ipLabel];
    [ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(30);
    }];
    
    self.modeSwitch = [[UISwitch alloc] init];
    self.modeSwitch.on = NO;
    [self.modeSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.modeSwitch];
    [self.modeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-40);
        make.top.equalTo(ipLabel.mas_bottom).with.offset(14);
    }];
    
    self.ipTF = [[UITextField alloc] init];
    self.ipTF.delegate = self;
    self.ipTF.placeholder = RZLocalizedString(@"DEVELOP_IPTF_PLACEHOLDER", @"开发者中心IP输入框的占位字符【请输入本地主机 IP】");
    self.ipTF.textColor = [UIColor darkGrayColor];
    self.ipTF.font = [UIFont systemFontOfSize:13];
    self.ipTF.leftViewMode = UITextFieldViewModeAlways;
    self.ipTF.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.08];
    self.ipTF.layer.cornerRadius = 5;
    self.ipTF.layer.masksToBounds = YES;
    [self.view addSubview:self.ipTF];
    [self.ipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.right.equalTo(self.modeSwitch.mas_left).with.offset(-28);
        make.centerY.equalTo(self.modeSwitch.mas_centerY);
        make.height.mas_equalTo(32);
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 32)];
    leftView.backgroundColor = [UIColor clearColor];
    self.ipTF.leftView = leftView;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringByCuttingEdgeWhiteSpaceAndNewlineCharacterSet:textField.text] forKey:kWebIPAddrKey];
}

#pragma mark - Action
- (void)switchAction:(UISwitch *)modeSwitch {
    if (modeSwitch.isOn) {
        if ([NSString isEmptyString:self.ipTF.text]) {
            self.modeSwitch.on = NO;
            return;
        }
        self.statusPoint.backgroundColor = [UIColor redColor];
        self.statusLabel.text = RZLocalizedString(@"DEVELOP_H5_DEVELOP_MODE", @"当前处于 H5 开发模式");
        self.ipTF.textColor = [UIColor blackColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringByCuttingEdgeWhiteSpaceAndNewlineCharacterSet:self.ipTF.text] forKey:kWebIPAddrKey];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kWebDevelopKey];
    } else {
        self.statusPoint.backgroundColor = [UIColor greenColor];
        self.statusLabel.text = RZLocalizedString(@"DEVELOP_H5_RELEASE_MODE", @"当前处于 H5 正式环境");
        self.ipTF.textColor = [UIColor grayColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kWebDevelopKey];
    }
}

@end
