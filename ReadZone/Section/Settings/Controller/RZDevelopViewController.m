//
//  RZDevelopViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/23.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZDevelopViewController.h"

@interface RZDevelopViewController ()

@property(nonatomic,strong) UIView *statusPoint;

@end

@implementation RZDevelopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
}

#pragma mark - DrawView
- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"DEVELOP_NAV_TITLE", @"开发者中心的导航栏标题【开发者中心】");
}

- (void)drawView {
    
    self.statusPoint = [[UIView alloc] init];
    
    UILabel *ipLabel = [[UILabel alloc] init];
    ipLabel.text = RZLocalizedString(@"DEVELOP_IP_LABEL", @"开发者中心 IP Label 的 Text【H5本地调试 IP】");
    ipLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    ipLabel.textColor = [UIColor blackColor];
    ipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ipLabel];
    [ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(26 + kNavTotalHeight);
    }];
    
    UITextField *ipTF = [[UITextField alloc] init];
    ipTF.placeholder = RZLocalizedString(@"DEVELOP_IPTF_PLACEHOLDER", @"开发者中心IP输入框的占位字符【请输入本地主机 IP】");
    ipTF.textColor = [UIColor darkGrayColor];
    ipTF.font = [UIFont systemFontOfSize:13];
    ipTF.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.08];
    ipTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    ipTF.layer.borderWidth = 0.5;
    ipTF.layer.cornerRadius = 5;
    ipTF.layer.masksToBounds = YES;
    [self.view addSubview:ipTF];
    [ipTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ipLabel.mas_bottom).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(200, 32));
        make.centerX.equalTo(self.view);
    }];
}

@end
