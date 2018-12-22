//
//  TSBaseNavigationController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseNavigationController.h"
#import "CommonLibrary.h"
#import "TIMServerHelper.h"
#import "TSIMAPlatform.h"
//#import <MLeaksFinder/NSObject+MemoryLeak.h>

@interface TSBaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation TSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // 设置导航栏透明（当 setBackgroundImage 的 Image 有 alpha 小于 1 时，即透明），以避免整个 ViewController 下移一个导航栏的高度（2018.12.22）
    //    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.98] size:CGSizeMake(10, 10)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:RGBOF(0xE3E2EE) size:CGSizeMake(1, 1)]];
    [self.navigationBar setTintColor:RGBOF(0x333333)];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBOF(0x333333),NSForegroundColorAttributeName, nil]];
    
    __weak TSBaseNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = weakSelf;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"TSBaseNavigationController dealloc");
}

//解决用leftbarbuttonitem自定义返回按钮，ios系统自带的右滑返回失效
#pragma mark - Override
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - ============ UINavigationControllerDelegate ============
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController respondsToSelector:@selector(YMHiddenNavigatorBar)]) {
        [self setNavigationBarHidden:YES animated:YES];
    }else{
        [self setNavigationBarHidden:NO animated:YES];
    }
    
    UIViewController *root = navigationController.viewControllers[0];
    
    if (root != viewController) {
        if (!viewController.navigationItem.leftBarButtonItem) {
            UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage tim_imageWithBundleAsset:@"ym_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
            viewController.navigationItem.leftBarButtonItem = itemleft;
        }
    } else {
        if (!viewController.navigationItem.leftBarButtonItem) {
            UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:[UIImage tim_imageWithBundleAsset:@"ym_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVCAction)];
            viewController.navigationItem.leftBarButtonItem = itemleft;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([self.viewControllers count] == 1) {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            if ([viewController respondsToSelector:@selector(YMDisablePopGesture)]) {
                self.interactivePopGestureRecognizer.enabled = NO;
            }else{
                self.interactivePopGestureRecognizer.enabled = YES;
            }
        }
    }
}

- (void)backAction {
    [self popViewControllerAnimated:YES];
}

- (void)dismissVCAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
