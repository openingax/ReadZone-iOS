//
//  RZBaseViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/29.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZBaseViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface RZBaseViewController ()

@end

@implementation RZBaseViewController
- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [self drawNavBar];
    [self drawNavBarItems];
    self.fd_prefersNavigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if (!self.navigationController || self.navigationController.viewControllers.count == 1)
    {
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

@end
