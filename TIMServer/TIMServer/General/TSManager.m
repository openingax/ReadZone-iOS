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
#import "TSUserManager.h"
#import "TSChatViewController.h"
#import "TSIMUser.h"

#import "TSIMManager.h"

@implementation TSManager

- (void)showMsgVCWithParams:(NSDictionary *)params controller:(UIViewController *)controller {
    
    [[TSUserManager shareInstance] saveUserAccount:params[@"account"] userSig:params[@"sig"]];
    
    TSIMUser *receiver = nil;
    if ([params[@"account"] isEqualToString:@"18814098638"]) {
        receiver = [[TSIMUser alloc] initWithUserId:@"13265028638"];
    };
    if ([params[@"account"] isEqualToString:@"13265028638"]) {
        receiver = [[TSIMUser alloc] initWithUserId:@"18814098638"];
    };
    
    TSChatViewController *listVC = [[TSChatViewController alloc] initWithUser:receiver];
    TSBaseNavigationController *navVC = [[TSBaseNavigationController alloc] initWithRootViewController:listVC];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navVC animated:YES completion:^{
        
    }];
    
    [TSIMManager shareInstance].topViewController = listVC;
}

@end
