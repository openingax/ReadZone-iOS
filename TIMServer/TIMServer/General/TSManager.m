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

@property(nonatomic,strong) TSAPIUser *userAPI;

@end

@implementation TSManager

- (void)showMsgVCWithAccount:(NSString *)account
                    nickName:(NSString *)nickName
                     faceURL:(NSString *)faceURL
                    deviceID:(NSString *)deviceID
                  controller:(UIViewController *)controller
{
    
    if (!self.userAPI) {
        self.userAPI = [[TSAPIUser alloc] init];
    }
//    [self.userAPI registerWithAccount:params[@"account"] userIcon:@"" complete:^(BOOL isSucc, NSString *message, NSDictionary *dict) {
//
//    }];
    
    
//    [[TSUserManager shareInstance] saveUserAccount:params[@"account"] userSig:params[@"sig"] receiver:params[@"receiver"]];
    if ([deviceID containsString:@"Viomi"]) {
        // C2C 会话
    } else if ([deviceID containsString:@"Viot"]){
        // Group 会话
    }
    
    [[TSUserManager shareInstance] saveDeviceID:deviceID];
    [[TSUserManager shareInstance] saveAccount:account];
    
//    TSIMUser *receiver = [[TSIMUser alloc] initWithUserId:deviceID];
    TIMUserProfile *profile = [[TIMUserProfile alloc] init];
    profile.identifier = deviceID;
    profile.nickname = @"";
    profile.faceURL = @"";
    
    TSIMUser *receiver = [[TSIMUser alloc] initWithUserInfo:profile];
    
    TSRichChatViewController *chatVC = [[TSRichChatViewController alloc] initWithUser:receiver];
    TSBaseNavigationController *navVC = [[TSBaseNavigationController alloc] initWithRootViewController:chatVC];
    
    [TSIMAPlatform config];
    
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [controller presentViewController:navVC animated:YES completion:^{
        
    }];
    
    [TSIMManager shareInstance].navigationController = navVC;
    [TSIMManager shareInstance].topViewController = chatVC;
}

- (void)loginTIM {
    TSRichChatViewController *chatVC = (TSRichChatViewController *)[TSIMManager shareInstance].topViewController;
    [chatVC loginNotiFromRN];
}

- (void)logoutTIM {
    [[TSUserManager shareInstance] deleteUserSig];
    
    [[TSIMAPlatform sharedInstance] logout:^{
        
    } fail:^(int code, NSString *msg) {
        
    }];
}

@end
