//
//  TSManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSManager.h"
#import "TSFriendListViewController.h"
#import "TSBaseNavigationController.h"

@implementation TSManager

- (void)showMsgVCWithParams:(NSDictionary *)params controller:(UIViewController *)controller {
    TSFriendListViewController *listVC = [[TSFriendListViewController alloc] init];
    TSBaseNavigationController *navVC = [[TSBaseNavigationController alloc] initWithRootViewController:listVC];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navVC animated:YES completion:^{
        
    }];
}

@end
