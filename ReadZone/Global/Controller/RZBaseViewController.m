//
//  RZBaseViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/29.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZBaseViewController.h"
#import "RZRootViewController.h"
#import "RZDebugView.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface RZBaseViewController ()

@property(nonatomic,assign) BOOL showDebugWindow;
@property(nonatomic,strong) RZDebugView *debugView;

@end

@implementation RZBaseViewController
{
    CGPoint panBeginPoint;
}
- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    self.navigationController.navigationBar.hidden = YES;
    
    [self drawNavBar];
    [self drawNavBarItems];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef Develop
    self.showDebugWindow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveDebugLog:) name:kDebugLogNotification object:nil];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AVAnalytics beginLogPageView:NSStringFromClass([self class])];
    
#ifdef Develop
    if (self.showDebugWindow) {
        UIView *lastView = [self.view.subviews lastObject];
        
        if (!_debugView) {
            _debugView = [[RZDebugView alloc] init];
        }
        [self.view insertSubview:_debugView aboveSubview:lastView];
        [_debugView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(kNavTotalHeight);
            make.right.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/3, 180));
        }];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_debugView addGestureRecognizer:panGes];
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AVAnalytics beginLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification
- (void)didReceiveDebugLog:(NSNotification *)noti {
    [_debugView debugLog:noti.object];
}

#pragma mark - draw
- (void)drawNavBar {
    __weak typeof(&*self) weakSelf = self;
    _navBar = [RZNavBar navBarWithTouchBackItemBlock:^(RZNavBarItem *backItem) {
        [weakSelf popViewController];
    }];
    _navBar.title = self.title;
    
    // 去掉导航栏底部的细线
    _navBar.backgroundImgView.tintColor = [UIColor whiteColor];
    _navBar.backgroundImg = [UIImage imageNamed:@"nav_bar_bottom_line"];
    
    [self.view addSubview:_navBar];
    [_navBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
}

- (void)drawNavBarItems {
    
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    _navBar.title = title;
}

- (void)touchNavBarBackItem:(RZNavBarItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (!self.navigationController || self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)popViewController
{
    [self touchNavBarBackItem:nil];
}

- (void)popSelfWithSomeActions {
    // 子类重写该方法
}

#pragma mark - Action
- (void)panGestureAction:(UIPanGestureRecognizer *)panGes {
    if (panGes.state == UIGestureRecognizerStateBegan) {
        panBeginPoint = [panGes locationInView:_debugView];
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [panGes locationInView:self.view];
        CGRect rect = _debugView.frame;
        rect.origin.x = current.x - panBeginPoint.x;
        rect.origin.y = current.y - panBeginPoint.y;
        _debugView.frame = rect;
        
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        
    }
}

@end
