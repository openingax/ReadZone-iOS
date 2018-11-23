//
//  TSConversation.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import "TSIMMsg.h"
#import "TSSafeMutableArray.h"
#import "CommonLibrary.h"

@class TSIMUser;

typedef void(^HandleMsgBlock)(NSArray *imMsgList, BOOL succ);
typedef void (^HandleMsgCodeBlock)(NSArray *imamsgList, BOOL succ, int code);
typedef void (^RemoveMsgBlock)(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction);

@interface TSConversation : NSObject
{
@protected
    TIMConversation     *_conversation;
    TSSafeMutableArray  *_msgList;
    TSIMMsg             *_lastMessage;
}

@property(nonatomic,strong) TIMConversation *conversation;
@property(nonatomic,readonly) TSSafeMutableArray *msgList;
@property(nonatomic,strong) TSIMMsg *lastMessage;
@property(nonatomic,copy) HandleMsgBlock receiveMsg;

- (instancetype)initWithConversation:(TIMConversation *)conv;

- (NSString *)receiver;
- (TIMConversationType)type;

// 主要用于启动的时候加载本地数据
- (void)asyncLoadLocalLastMsg:(CommonVoidBlock)block;

- (void)releaseConversation;

- (void)onReceiveNewMessage:(TSIMMsg *)msg;

- (NSArray *)sendMessage:(TSIMMsg *)msg completion:(HandleMsgCodeBlock)block;

@end
