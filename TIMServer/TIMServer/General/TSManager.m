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

#import "TSAPIUser.h"
//#import <TXLiteAVSDK_Professional/TXUGCBase.h>

@interface TSManager ()

@property(nonatomic,assign) TSAPIUser *userAPI;

@end

@implementation TSManager

- (void)showMsgVCWithParams:(NSDictionary *)params controller:(UIViewController *)controller {
    
    [[TSUserManager shareInstance] saveUserAccount:params[@"account"] userSig:params[@"sig"] receiver:params[@"receiver"]];
    
    TSIMUser *receiver = [[TSIMUser alloc] initWithUserId:params[@"receiver"]];
    
    TSRichChatViewController *chatVC = [[TSRichChatViewController alloc] initWithUser:receiver];
    TSBaseNavigationController *navVC = [[TSBaseNavigationController alloc] initWithRootViewController:chatVC];
    
    [TSIMAPlatform config];
//    [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/2cbbd6c13014ceca75107573f7890ddd/TXUgcSDK.licence" key:@"409ec0b6be2c46d71900b5bdb9430d05"];
    
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navVC animated:YES completion:^{
        
    }];
    
    [TSIMManager shareInstance].navigationController = navVC;
    [TSIMManager shareInstance].topViewController = chatVC;
    
    
}

@end
