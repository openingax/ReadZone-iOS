//
//  RZTIMViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/12/20.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZTIMViewController.h"
#import <Masonry/Masonry.h>
#import <TIMServer/TSManager.h>
#import <UIImageView+WebCache.h>

@interface RZTIMViewController ()

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *msgLabel;
@property(nonatomic,strong) UIButton *showTIMBtn;
@property(nonatomic,strong) TSManager *tsManager;
@property(nonatomic,assign) BOOL hasLoginTIM;
@property(nonatomic,assign) BOOL isEnterTIM;

@end

@implementation RZTIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTIMServerLogin:) name:TIMLoginSuccNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiverNewMsg:) name:TIMNewMsgNotification object:nil];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self addOwnViews];
    
    self.tsManager = [[TSManager alloc] init];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tsManager loginTIMWithAccount:[@"" stringByAppendingString:[RZUserManager shareInstance].account] nickName:[RZUserManager shareInstance].account faceURL:@"http://lc-2qF4yFo6.cn-n1.lcfile.com/QTeHivAJVIyEAT0wjv6kN2C" deviceID:@"viot85396846"];
        [self.tsManager loginTIMWithAccount:[@"" stringByAppendingString:[RZUserManager shareInstance].account] nickName:[RZUserManager shareInstance].account faceURL:@"http://lc-2qF4yFo6.cn-n1.lcfile.com/QTeHivAJVIyEAT0wjv6kN2C" deviceID:@"@TGS#2CVADKTFD"];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isEnterTIM = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // TIM server logout
    if (!_isEnterTIM && self.tsManager) {
        [self.tsManager logoutTIM];
    }
}

- (void)didReceiverNewMsg:(NSNotification *)noti {
    BOOL hasNewMsg = [noti.userInfo[TIMNewMsgStatusUserInfoKey] boolValue];
    if (hasNewMsg) {
        _msgLabel.text = @"有新消息喔";
    } else {
        _msgLabel.text = @"";
    }
}


- (void)addOwnViews {
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.textColor = [UIColor redColor];
    _msgLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_msgLabel];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavTotalHeight + 18);
        make.right.equalTo(self.view).with.offset(-20);
    }];
    
    _showTIMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showTIMBtn.hidden = YES;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"SHOW TIM" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:24 weight:UIFontWeightBold], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [_showTIMBtn setAttributedTitle:str forState:UIControlStateNormal];
    [_showTIMBtn addTarget:self action:@selector(showTIM) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showTIMBtn];
    [_showTIMBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *dismissStr = [[NSMutableAttributedString alloc] initWithString:@"DISMISS" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:24 weight:UIFontWeightBold], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [dismissBtn setAttributedTitle:dismissStr forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showTIMBtn.mas_bottom).with.offset(50);
        make.centerX.equalTo(self.view);
    }];
}

- (void)layoutSubviews {
    
}

- (void)didTIMServerLogin:(NSNotification *)noti {
    BOOL hasLogin = [noti.userInfo[TIMLoginSuccStatusUserInfoKey] boolValue];
    if (hasLogin) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://lc-2qF4yFo6.cn-n1.lcfile.com/8958b8980432e685b4d1.JPG"]];
        _showTIMBtn.hidden = NO;
    } else {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://lc-2qF4yFo6.cn-n1.lcfile.com/QTeHivAJVIyEAT0wjv6kN2C"]];
        _showTIMBtn.hidden = YES;
    }
}

- (void)showTIM {
    self.isEnterTIM = YES;
    [self.tsManager showTIMWithController:self];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
