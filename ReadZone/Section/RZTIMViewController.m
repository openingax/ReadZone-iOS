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
@property(nonatomic,strong) UIButton *showTIMBtn;
@property(nonatomic,strong) TSManager *tsManager;
@property(nonatomic,assign) BOOL isEnterTIM;

@end

@implementation RZTIMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTIMServerLogin:) name:TIMLoginSuccNotification object:nil];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self addOwnViews];
    
    self.tsManager = [[TSManager alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isEnterTIM = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tsManager loginTIMWithAccount:[@"" stringByAppendingString:[RZUserManager shareInstance].account] nickName:[RZUserManager shareInstance].account faceURL:@"http://lc-2qF4yFo6.cn-n1.lcfile.com/QTeHivAJVIyEAT0wjv6kN2C" deviceID:@"viot85396840"];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // TIM server logout
    if (!_isEnterTIM && self.tsManager) {
        [self.tsManager logoutTIM];
    }
}

- (void)addOwnViews {
    _imgView = [[UIImageView alloc] init];
    _imgView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
        [_imgView sd_setImageWithURL:[NSURL URLWithString:@"http://lc-2qF4yFo6.cn-n1.lcfile.com/QTeHivAJVIyEAT0wjv6kN2C"]];
        _showTIMBtn.hidden = NO;
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
