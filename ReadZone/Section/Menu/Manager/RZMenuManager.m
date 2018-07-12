//
//  RZMenuManager.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/12.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZMenuManager.h"
#import "RZMenuViewController.h"
#import "RZBaseNavigationController.h"

@implementation RZMenuManager

- (void)showMenuVCWithController:(UIViewController *)controller {
    RZMenuViewController *menuVC = [[RZMenuViewController alloc] init];
    RZBaseNavigationController *navVC = [[RZBaseNavigationController alloc] initWithRootViewController:menuVC];
    navVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [controller presentViewController:navVC animated:NO completion:^{
        
    }];
}

@end
