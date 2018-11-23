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

- (void)onReceiveNewMessage:(TSIMMsg *)msg {
    NSMutableArray *array = [NSMutableArray array];
    TSIMMsg *timeTip = [self timeTipOnNewMessage:msg];
    
    if (timeTip) {
        [array addObject:timeTip];
    }
    
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
#warning 先设为30秒提醒一次
        if (timeInterval > 1 * 30) {
            TSIMMsg *newMsg = [TSIMMsg msgWithDate:followDate];
            return newMsg;
        }
    }
    
    return nil;
}

- (NSArray *)sendMessage:(TSIMMsg *)msg completion:(HandleMsgCodeBlock)block {
    if (msg) {
        
        NSMutableArray *array = [self addMsgToList:msg];
        
        [msg statusChangeTo:TSIMMsgStatusSending needRefresh:NO];
        
        [_conversation sendMessage:msg.msg succ:^{
            [msg statusChangeTo:TSIMMsgStatusSendSucc needRefresh:YES];
            
            if (block) {
                block(array, YES, 0);
            }
            
        } fail:^(int code, NSString *error) {
            [msg statusChangeTo:TSIMMsgStatusSendFail needRefresh:YES];
            NSLog(@"信息发送失败");
            
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
