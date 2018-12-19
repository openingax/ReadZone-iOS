//
//  TSConversation.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <IMMessageExt/IMMessageExt.h>
#import "TSIMMsg.h"
#import "TSSafeMutableArray.h"
#import "CommonLibrary.h"
#import <libextobjc/EXTScope.h>

@class TSIMUser, TSConversation;

typedef void(^HandleMsgBlock)(NSArray *imMsgList, BOOL succ);
typedef void (^HandleMsgCodeBlock)(NSArray *imamsgList, BOOL succ, int code);
typedef void (^RemoveMsgBlock)(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction);

@protocol TSConversationDelegate <NSObject>

- (void)conversation:(TSConversation *)conv didReceiveNewMsg:(NSArray *)msgList succ:(BOOL)succ;

@end

@interface TSConversation : NSObject
{
@protected
    TIMConversation     *_conversation;
    TSSafeMutableArray  *_msgList;
    TSIMMsg             *_lastMessage;
}

@property(nonatomic,weak) id <TSConversationDelegate> delegate;

@property(nonatomic,strong) TIMConversation *conversation;
@property(nonatomic,readonly) TSSafeMutableArray *msgList;
@property(nonatomic,strong) TSIMMsg *lastMessage;
@property(nonatomic,copy) HandleMsgBlock receiveMsg;

- (instancetype)initWithConversation:(TIMConversation *)conv;

- (void)copyConversationInfo:(TSConversation *)conv;

- (NSString *)receiver;
- (TIMConversationType)type;

// 主要用于启动的时候加载本地数据
- (void)asyncLoadLocalLastMsg:(CommonVoidBlock)block;

- (void)releaseConversation;

// 切换到本会话前，先加载本地的最后count条聊天的的数据
- (void)asyncLoadRecentMessage:(NSInteger)count completion:(HandleMsgBlock)block;

// 用于顶部下拉加载更多历史消息
- (void)asyncLoadRecentMessage:(NSInteger)count from:(TSIMMsg *)msg completion:(HandleMsgBlock)block;

- (void)onReceiveNewMessage:(TSIMMsg *)msg;

- (NSArray *)sendMessage:(TSIMMsg *)msg completion:(HandleMsgCodeBlock)block;
- (NSArray *)appendWillSendMsg:(TSIMMsg *)msg completion:(HandleMsgBlock)block;
- (void)replaceWillSendMsg:(TSIMMsg *)msg with:(TSIMMsg *)newMsg completion:(HandleMsgBlock)block;
- (NSArray *)removeMsg:(TSIMMsg *)msg completion:(RemoveMsgBlock)block;
- (NSArray *)revokeMsg:(TSIMMsg *)msg isRemote:(BOOL)isRemote completion:(RemoveMsgBlock)block;

- (void)setReadAllMsg;
- (NSInteger)unReadCount;

- (void)setLocalDraft:(TIMMessageDraft *)msgDraft;
- (TIMMessageDraft *)getLocalDraft;

@end
