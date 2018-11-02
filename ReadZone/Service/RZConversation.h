//
//  RZConversation.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import "RZSafeMutableArray.h"
#import "RZIMMsg.h"

@class RZIMUser;

typedef void(^HandleMsgBlock)(NSArray *imMsgList, BOOL succ);
typedef void (^HandleMsgCodeBlock)(NSArray *imamsgList, BOOL succ, int code);

@interface RZConversation : NSObject
{
@protected
    TIMConversation     *_conversation;
    RZSafeMutableArray  *_msgList;
    RZIMMsg             *_lastMessage;
}

@property(nonatomic,strong) TIMConversation *conversation;
@property(nonatomic,readonly) RZSafeMutableArray *msgList;
@property(nonatomic,strong) RZIMMsg *lastMessage;
@property(nonatomic,copy) HandleMsgBlock receiveMsg;

- (instancetype)initWithConversation:(TIMConversation *)conv;

- (NSString *)receiver;
- (TIMConversationType)type;

- (void)onReceiveNewMessage:(RZIMMsg *)msg;

- (NSArray *)sendMessage:(RZIMMsg *)msg completion:(HandleMsgCodeBlock)block;

@end
