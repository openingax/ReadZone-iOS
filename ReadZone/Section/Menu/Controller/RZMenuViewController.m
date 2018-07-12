//
//  RZMenuViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/12.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZMenuViewController.h"
#import <pop/pop.h>

static CGFloat containerWidth;

@interface RZMenuViewController () <POPAnimationDelegate>

@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,assign) BOOL isShow;

@end

@implementation RZMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    containerWidth = kScreenWidth*0.62;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showAnimation];
}

- (void)drawNavBar {
    [super drawNavBar];
    self.navBar.hidden = YES;
}

- (void)drawView {
    // 设置背景渐变动画相关的参数
    self.view.layer.opacity = 0.0;
    [self.view.layer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, containerWidth, kScreenHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    UIView *leftTapView = [[UIView alloc] init];
    [leftTapView addGestureRecognizer:tap];
    leftTapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftTapView];
    [leftTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.right.equalTo(self.containerView.mas_left);
    }];
}

#pragma mark - Animation
- (void)showAnimation {
    self.isShow = YES;
    [self.view pop_removeAllAnimations];
    [self.containerView pop_removeAllAnimations];
    self.view.layer.opacity = 1.0;
    self.containerView.layer.opacity = 1;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.delegate = self;
    anim.fromValue = @(kScreenWidth + containerWidth/2);
    anim.toValue = @(kScreenWidth - containerWidth/2);
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.delegate = self;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @1;
    
//    [self.view.layer pop_addAnimation:opacityAnim forKey:@"ShowAnimationOpacity"];
    [self.containerView.layer pop_addAnimation:anim forKey:@"AnimationPositionX"];
}

- (void)hideAnimation {
    self.isShow = NO;
    [self.view pop_removeAllAnimations];
    [self.containerView pop_removeAllAnimations];
    self.view.layer.opacity = 1.0;
    
    POPBasicAnimation *opacityAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnim.delegate = self;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnim.duration = 0.25;
    opacityAnim.toValue = @0;
    
    [self.view.layer pop_addAnimation:opacityAnim forKey:@"HideAnimationOpacity"];
}

#pragma mark - POPAnimationDelegate
- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    if (!self.isShow) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - Action
- (void)tapAction {
    [self hideAnimation];
}

@end
