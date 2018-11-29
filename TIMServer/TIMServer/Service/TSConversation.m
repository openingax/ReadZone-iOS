//
//  TSConversation.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSConversation.h"
#import <IMMessageExt/IMMessageExt.h>

#define kSaftyWordsCode 80001

@implementation TSConversation

- (instancetype)initWithConversation:(TIMConversation *)conv {
    if (self = [super init]) {
        _conversation = conv;
        _msgList = [[TSSafeMutableArray alloc] init];
    }
    return self;
}

- (NSString *)receiver {
    return [_conversation getReceiver];
}

- (TIMConversationType)type {
    return [_conversation getType];
}

- (void)releaseConversation
{
    [_msgList removeAllObjects];
    _receiveMsg = nil;
}

- (void)copyConversationInfo:(TSConversation *)conv {
    _msgList = conv.msgList;
    _lastMessage = [conv lastMessage];
    _receiveMsg = conv.receiveMsg;
}

// 主要用于启动的时候加载本地数据
- (void)asyncLoadLocalLastMsg:(CommonVoidBlock)block {
    NSArray *msgs = [_conversation getLastMsgs:20];
    NSMutableArray *lastMsgs = [[NSMutableArray alloc] init];
    for (TIMMessage *msg in msgs) {
        if (msg.status != TIM_MSG_STATUS_LOCAL_REVOKED) {
            TSIMMsg *imMsg = [TSIMMsg msgWithMsg:msg];
            if (imMsg) {
                [lastMsgs addObject:[imMsg msgTip]];
                self.lastMessage = imMsg;
            }
        }
    }
    
    if (block) {
        block(lastMsgs);
    }
}

// 切换到本会话前，先加载本地的最后10条聊天的的数据
- (void)asyncLoadRecentMessage:(NSInteger)count completion:(HandleMsgBlock)block;
{
    TSIMMsg *top = [self vailedTopMsg];
    [self asyncLoadRecentMessage:count from:top completion:block];
}

// 用于顶部下拉加载更多历史消息
- (void)asyncLoadRecentMessage:(NSInteger)count from:(TSIMMsg *)msg completion:(HandleMsgBlock)block
{
    __weak TSConversation *ws = self;
    [_conversation getMessage:(int)count last:msg.msg succ:^(NSArray *array) {
        
        NSArray *recentIMAMsg = [ws onLoadRecentMessageSucc:array];
        if (block)
        {
            block(recentIMAMsg, recentIMAMsg.count != 0);
        }
    } fail:^(int code, NSString *err) {
        DebugLog(@"未取到最后一条消息");
        if (block)
        {
            block(nil, NO);
        }
    }];
}

- (void)onReceiveNewMessage:(TSIMMsg *)msg {
    NSMutableArray *array = [NSMutableArray array];
    
#warning 暂时屏蔽时间提示
//    TSIMMsg *timeTip = [self timeTipOnNewMessage:msg];
//    // 时间提示
//    if (timeTip) {
//        [array addObject:timeTip];
//    }
    
    [array addObject:msg];
    
    [_msgList addObjectsFromArray:array];
    if (_receiveMsg) {
        _receiveMsg(array, YES);
    }
}

- (TSIMMsg *)timeTipOnNewMessage:(TSIMMsg *)msg {
    if (_lastMessage) {
        NSDate *lastDate = [_lastMessage.msg timestamp];
        NSDate *followDate = [msg.msg timestamp];
        
        NSTimeInterval timeInterval = [followDate timeIntervalSinceDate:lastDate];
#warning 设置时间提醒时间间隔
        if (timeInterval > 3 * 60) {
            TSIMMsg *newMsg = [TSIMMsg msgWithDate:followDate];
            return newMsg;
        }
    }
    
    return nil;
}

- (NSArray *)onLoadRecentMessageSucc:(NSArray *)timmsgList
{
    if (timmsgList.count > 0)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger idx = timmsgList.count - 1;
        TIMMessage *temp = nil;
        do
        {
            TIMMessage *msg = timmsgList[idx];
            //            if (msg.status == TIM_MSG_STATUS_HAS_DELETED)
            //            {
            //                idx--;
            //                continue;
            //            }
            
            NSDate *date = [msg timestamp];
            if (idx == timmsgList.count - 1)
            {
                // 插入标签
                TSIMMsg *timeTip = [TSIMMsg msgWithDate:date];
                [array addObject:timeTip];
            }
            
            if (temp)
            {
                NSDate *lastDate = [temp timestamp];
                
                NSTimeInterval timeinterval = [date timeIntervalSinceDate:lastDate];
                if (timeinterval > 5 * 60)
                {
                    // 大于五分钟
                    TSIMMsg *msg = [TSIMMsg msgWithDate:date];
                    [array addObject:msg];
                }
            }
            temp = msg;
            if (msg.status == TIM_MSG_STATUS_LOCAL_REVOKED) {//撤销
//                TSIMMsg *imamsg = [TSIMMsg msgWithRevoked:msg.sender];
//                if (imamsg)
//                {
//                    [array addObject:imamsg];
//                }
            }
            else {
//                TSIMMsg *imamsg = [TSIMMsg msgWith:msg];
//                if (imamsg)
//                {
//                    [array addObject:imamsg];
//                }
            }
            idx--;
        }
        while (idx >= 0);
        
        [_msgList insertObjectsFromArray:array atIndex:0];
        return array;
    }
    
    return nil;
}

- (NSArray *)sendMessage:(TSIMMsg *)msg completion:(HandleMsgCodeBlock)block {
    if (msg) {
        
        NSMutableArray *array = [self addMsgToList:msg];
        
        [msg changeTo:TSIMMsgStatusSending needRefresh:NO];
        
        [_conversation sendMessage:msg.msg succ:^{
            [msg changeTo:TSIMMsgStatusSendSucc needRefresh:YES];
            
            if (block) {
                block(array, YES, 0);
            }
            
        } fail:^(int code, NSString *error) {
            [msg changeTo:TSIMMsgStatusSendFail needRefresh:YES];
            NSLog(@"信息发送失败\ncode:%d  %@", code, error);
            
            if (code != kSaftyWordsCode) {
                
            }
            
            if (block) {
                block(array, NO, code);
            }
        }];
        
        return array;
    }
    return nil;
}

- (TSIMMsg *)vailedTopMsg
{
    NSInteger count = [_msgList count];
    if (count > 0)
    {
        NSInteger index = 0;
        do
        {
            TSIMMsg *msg = [_msgList objectAtIndex:index];
            if ([msg isValiedType])
            {
                return msg;
            }
            index++;
        }
        while (index < count);
    }
    
    return nil;
}

- (NSMutableArray *)addMsgToList:(TSIMMsg *)msg {
    if (msg) {
        NSMutableArray *array = [NSMutableArray array];
        TSIMMsg *timeTip = [self timeTipOnNewMessage:msg];
        if (timeTip) {
            [array addObject:timeTip];
        }
        
        self.lastMessage = msg;
        [array addObject:msg];
        [_msgList addObjectsFromArray:array];
        
        return array;
    }
    return nil;
}

@end
