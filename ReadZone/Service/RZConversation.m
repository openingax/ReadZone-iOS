//
//  RZConversation.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZConversation.h"
#import "RZIMMsg.h"

#define kSaftyWordsCode 80001

@implementation RZConversation

- (instancetype)initWithConversation:(TIMConversation *)conv {
    if (self = [super init]) {
        _conversation = conv;
        _msgList = [[RZSafeMutableArray alloc] init];
    }
    return self;
}

- (NSString *)receiver {
    return [_conversation getReceiver];
}

- (TIMConversationType)type {
    return [_conversation getType];
}

- (void)onReceiveNewMessage:(RZIMMsg *)msg {
    NSMutableArray *array = [NSMutableArray array];
    RZIMMsg *timeTip = [self timeTipOnNewMessage:msg];
    
    if (timeTip) {
        [array addObject:timeTip];
    }
    
    [array addObject:msg];
    
    [_msgList addObjectsFromArray:array];
    if (_receiveMsg) {
        _receiveMsg(array, YES);
    }
}

- (RZIMMsg *)timeTipOnNewMessage:(RZIMMsg *)msg {
    if (_lastMessage) {
        NSDate *lastDate = [_lastMessage.msg timestamp];
        NSDate *followDate = [msg.msg timestamp];
        
        NSTimeInterval timeInterval = [followDate timeIntervalSinceDate:lastDate];
#warning 先设为30秒提醒一次
        if (timeInterval > 1 * 30) {
            RZIMMsg *newMsg = [RZIMMsg msgWithDate:followDate];
            return newMsg;
        }
    }
    
    return nil;
}

- (NSArray *)sendMessage:(RZIMMsg *)msg completion:(HandleMsgCodeBlock)block {
    if (msg) {
        
        NSMutableArray *array = [self addMsgToList:msg];
        
        [msg statusChangeTo:RZIMMsgStatusSending needRefresh:NO];
        
        [_conversation sendMessage:msg.msg succ:^{
            [msg statusChangeTo:RZIMMsgStatusSendSucc needRefresh:YES];
            
            if (block) {
                block(array, YES, 0);
            }
            
        } fail:^(int code, NSString *error) {
            [msg statusChangeTo:RZIMMsgStatusSendFail needRefresh:YES];
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

- (NSMutableArray *)addMsgToList:(RZIMMsg *)msg {
    if (msg) {
        NSMutableArray *array = [NSMutableArray array];
        RZIMMsg *timeTip = [self timeTipOnNewMessage:msg];
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
