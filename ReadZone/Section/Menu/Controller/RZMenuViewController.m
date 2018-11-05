//
//  RZMenuViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/12.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

// Vendor
#import <pop/pop.h>
#import <SDWebImage/UIImageView+WebCache.h>

// View
#import "RZMenuButton.h"

// Controller
#import "RZMenuViewController.h"
#import "RZSettingViewController.h"
//#import "RZMsgViewController.h"

static CGFloat containerWidth;

@interface RZMenuViewController () <POPAnimationDelegate>

@property(nonatomic,strong) UIView *backgroundView;
@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,assign) BOOL isShow;                // 菜单是否已显示
@property(nonatomic,assign) BOOL isAnimating;           // 动画是否进行中
@property(nonatomic,assign) BOOL isEnterNextVC;         // 是否进入了下一级页面

@end

@implementation RZMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    containerWidth = kScreenWidth*0.62;
    [self drawView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginEvent:) name:kLoginSuccessNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.isEnterNextVC) {
        // 如果没进入下一级页面
        [self showAnimation];
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[RZUser shared].userInfo.userAvatar] placeholderImage:nil];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    self.isEnterNextVC = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isEnterNextVC) {
        self.backgroundView.layer.opacity = 0;
        self.containerView.layer.opacity = 0;
    }
}

#pragma mark - Event
- (void)loginEvent:(NSNotification *)noti {
    RZUserModel *userModel = noti.object;
    self.userName = userModel.userName;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:userModel.userAvatar]];
}


#pragma mark - DrawView
- (void)drawNavBar {
    [super drawNavBar];
    self.navBar.hidden = YES;
}

- (void)drawView {
    self.view.backgroundColor = [UIColor clearColor];
    
    // 设置背景渐变动画相关的参数
    self.backgroundView = [[UIView alloc] initWithFrame:kScreenBounds];
    [self.backgroundView.layer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor];
    self.backgroundView.layer.opacity = 0;
    [self.view addSubview:self.backgroundView];
    
    // 给背影视图添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.backgroundView addGestureRecognizer:tap];
    
    // 容器视图
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-containerWidth, 0, containerWidth, kScreenHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.opacity = 0;
    [self.view addSubview:self.containerView];
    
    // 用户头像
    self.avatarImgView = [[UIImageView alloc] init];
    self.avatarImgView.backgroundColor = [UIColor lightGrayColor];
    self.avatarImgView.layer.cornerRadius = 40;
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.userInteractionEnabled = YES;
    [self.containerView addSubview:self.avatarImgView];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(kNavTotalHeight -10);
        make.centerX.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingBtnAction)];
    [self.avatarImgView addGestureRecognizer:avatarTap];
    
    // 用户名
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.text = [RZUser shared].userInfo.userName;
    userNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    userNameLabel.textColor = [UIColor blackColor];
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImgView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.containerView);
    }];
    
    // 四个功能按钮
    RZMenuButton *msgBtn = [RZMenuButton buttonWithTitle:RZLocalizedString(@"MENU_BUTTON_MESSAGE", @"菜单栏消息按钮标题【消息】")];
    RZMenuButton *noteBtn = [RZMenuButton buttonWithTitle:RZLocalizedString(@"MENU_BUTTON_NOTE", @"菜单栏记录按钮标题【记录】")];
    RZMenuButton *offlineBtn = [RZMenuButton buttonWithTitle:RZLocalizedString(@"MENU_BUTTON_OFFLINE", @"菜单栏离线按钮标题【离线】")];
    RZMenuButton *settingBtn = [RZMenuButton buttonWithTitle:RZLocalizedString(@"MENU_BUTTON_SETTING", @"菜单栏设置按钮标题【设置】")];
    
    [msgBtn addTarget:self action:@selector(msgBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [noteBtn addTarget:self action:@selector(noteBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [offlineBtn addTarget:self action:@selector(offlineBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.containerView addSubview:msgBtn];
    [self.containerView addSubview:noteBtn];
    [self.containerView addSubview:offlineBtn];
    [self.containerView addSubview:settingBtn];
    
    [noteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.mas_centerY).with.offset(20*kScreenRatio());
        make.centerX.equalTo(self.containerView);
    }];
    [offlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_centerY).with.offset((50*kScreenRatio()));
        make.centerX.equalTo(self.containerView);
    }];
    [msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(noteBtn.mas_top).with.offset(-(30*kScreenRatio()));
        make.centerX.equalTo(self.containerView);
    }];
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(offlineBtn.mas_bottom).with.offset(30*kScreenRatio());
        make.centerX.equalTo(self.containerView);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = @"V 1.0.0";
    [self.containerView addSubview:versionLabel];
    
    UILabel *appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = RZLocalizedString(@"MENU_APP_NAME", @"App 名称");
    appNameLabel.textColor = [UIColor blackColor];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    appNameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self.containerView addSubview:appNameLabel];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView).with.offset(kIsiPhoneX ? -38 : -14);
        make.centerX.equalTo(self.containerView);
    }];
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(versionLabel.mas_top).with.offset(-10);
        make.centerX.equalTo(self.containerView);
    }];
}

#pragma mark - Animation
- (void)showAnimation {
    self.isShow = YES;
    self.isAnimating = YES;
    [self.backgroundView pop_removeAllAnimations];
    [self.containerView pop_removeAllAnimations];
    self.backgroundView.layer.opacity = 0;
    self.containerView.layer.opacity = 1.0;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.delegate = self;
    anim.fromValue = @(kScreenWidth + containerWidth/2);
    anim.toValue = @(kScreenWidth - containerWidth/2);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.delegate = self;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @1;
    
    [self.containerView.layer pop_addAnimation:anim forKey:@"AnimationPositionX"];
    [self.backgroundView.layer pop_addAnimation:opacityAnim forKey:@"ShowAnimationOpacity"];
}

- (void)hideAnimation {
    self.isShow = NO;
    self.isAnimating = YES;
    [self.backgroundView pop_removeAllAnimations];
    [self.containerView pop_removeAllAnimations];
    self.backgroundView.layer.opacity = 1.0;
    self.containerView.layer.opacity = 1.0;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.delegate = self;
    anim.fromValue = @(kScreenWidth - containerWidth/2);
    anim.toValue = @(kScreenWidth + containerWidth/2);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.delegate = self;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @0;
    
    [self.containerView.layer pop_addAnimation:anim forKey:@"HideAnimationPositionX"];
    [self.backgroundView.layer pop_addAnimation:opacityAnim forKey:@"HideAnimationOpacity"];
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    self.isAnimating = NO;
    if (!self.isShow) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Action
- (void)tapAction {
    if (!self.isAnimating) {
        [self hideAnimation];
    }
}

- (void)msgBtnAction {
    self.isEnterNextVC = YES;
//    RZMsgViewController *msgVC = [[RZMsgViewController alloc] init];
//    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void)noteBtnAction {
    self.isEnterNextVC = YES;
}

- (void)offlineBtnAction {
    self.isEnterNextVC = YES;
}

- (void)settingBtnAction {
    self.isEnterNextVC = YES;
    RZSettingViewController *settingVC = [[RZSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end
