//
//  RZBaseNavigationController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZBaseNavigationController.h"
#import "RZBaseViewController.h"

@interface RZBaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation RZBaseNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏取消透明
    [self.navigationBar setTranslucent:NO];
    
    UIColor *titleColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:20];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          titleColor, NSForegroundColorAttributeName,
                          titleFont, NSFontAttributeName,
                          nil];
    self.navigationBar.titleTextAttributes = dict;
    
    // 分割线颜色
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageNamed:@"nav_bar_bottom_line"]];
    
    //解决用leftbarbuttonitem自定义返回按钮，ios系统自带的右滑返回失效（要在push转换viewcontroller的时候禁用interactivePopGestureRecognizer，在viewcontroller显示的时候启用）
    __weak RZBaseNavigationController *weakself = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakself;
        self.delegate = weakself;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//解决用leftbarbuttonitem自定义返回按钮，ios系统自带的右滑返回失效
#pragma mark - Override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *popVC = [super popViewControllerAnimated:animated];
    if ([popVC isKindOfClass:[RZBaseViewController class]]) {
        [(RZBaseViewController *)popVC popSelfWithSomeActions];
    }
    
    return popVC;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([self.viewControllers count] == 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

@end
