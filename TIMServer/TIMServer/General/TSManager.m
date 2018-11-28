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
#import "TSRichChatViewController.h"
#import "TSIMUser.h"
#import "TSIMAPlatform.h"
#import "TSIMManager.h"
#import "IMAPlatformConfig.h"

@implementation TSManager

- (void)showMsgVCWithParams:(NSDictionary *)params controller:(UIViewController *)controller {
    
    [[TSUserManager shareInstance] saveUserAccount:params[@"account"] userSig:params[@"sig"]];
    
    TSIMUser *receiver = [[TSIMUser alloc] initWithUserId:@"86-18814098638"];
    
    TSRichChatViewController *listVC = [[TSRichChatViewController alloc] initWithUser:receiver];
    TSBaseNavigationController *navVC = [[TSBaseNavigationController alloc] initWithRootViewController:listVC];
    
    [TSIMAPlatform config];
    
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navVC animated:YES completion:^{
        
    }];
    
    [TSIMManager shareInstance].topViewController = listVC;
}

@end
