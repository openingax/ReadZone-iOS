//
//  TSIMAPlatform+IMSDKCallBack.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/26.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMAPlatform+IMSDKCallBack.h"

@implementation TSIMAPlatform (IMSDKCallBack)

- (void)onRefresh {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMgr asyncConversationList];
        [[TIMManager sharedInstance] addMessageListener:self.conversationMgr];
    });
}

- (void)onRefreshConversations:(NSArray *)conversations {
    [self.conversationMgr asyncConversationList];
}

- (void)OnRefreshTicketFail:(TLSErrInfo *)errInfo {
    
}

- (void)OnRefreshTicketSuccess:(TLSUserInfo *)userInfo {
    
}

- (void)OnRefreshTicketTimeout:(TLSErrInfo *)errInfo {
    
}

@end
