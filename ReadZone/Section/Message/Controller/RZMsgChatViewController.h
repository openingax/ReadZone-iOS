//
//  RZMsgChatViewController.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <TIMServer/TIMServer.h>

#import "RZBaseViewController.h"
#import "TIMUserProfile+RZ.h"
#import "RZConversation.h"

NS_ASSUME_NONNULL_BEGIN

@class TIMConversation;

@interface RZMsgChatViewController : RZBaseViewController
{
@protected
    RZConversation                  *_conversation;
    RZIMUser                        *_receiver;
    __weak RZSafeMutableArray       *_messageList;
}

@property(nonatomic,strong) RZConversation *conversation;
@property(nonatomic,strong) RZIMUser *receiver;
@property(nonatomic,readonly) RZSafeMutableArray *messageList;

- (instancetype)initWithUser:(RZIMUser *)user;

- (void)configWithUser:(RZIMUser *)user;
- (void)appendReceiveMessage;

@end

NS_ASSUME_NONNULL_END
