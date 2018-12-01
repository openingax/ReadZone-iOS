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
    } else {
        // 如果 _receiveMsg 不存在，检查用户登录状态
        [[TIMManager sharedInstance] getLoginStatus];
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


#pragma mark - 发送消息
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

- (NSArray *)appendWillSendMsg:(TSIMMsg *)msg completion:(HandleMsgBlock)block {
    if (msg)
    {
        NSArray *array = [self addMsgToList:msg];
        
        [msg changeTo:TSIMMsgStatusWillSending needRefresh:YES];
        
        if (block)
        {
            block(array, YES);
        }
        return array;
        
    }
    return nil;
}

- (void)replaceWillSendMsg:(TSIMMsg *)msg with:(TSIMMsg *)newMsg completion:(HandleMsgBlock)block
{
    if (msg && newMsg)
    {
        // 还未真正地删除，先只是同步到列表中
        NSInteger oldIdx = [_msgList indexOfObject:msg];
        NSInteger count = [_msgList count];
        if (oldIdx >= 0 && oldIdx < count)
        {
            [newMsg changeTo:TSIMMsgStatusSending needRefresh:YES];
            [_msgList replaceObjectAtIndex:oldIdx withObject:newMsg];
            if (self.lastMessage == msg)
            {
                self.lastMessage = newMsg;
            }
            NSArray *reapceArray = @[[_msgList objectAtIndex:oldIdx]];
            if (block)
            {
                block(reapceArray, YES);
            }
            
            [_conversation sendMessage:newMsg.msg succ:^{
                [newMsg changeTo:TSIMMsgStatusSendSucc needRefresh:YES];
            } fail:^(int code, NSString *err) {
                [newMsg changeTo:TSIMMsgStatusSendFail needRefresh:YES];
                DebugLog(@"发送消息失败");
            }];
        }
    }
}

- (NSArray *)removeMsg:(TSIMMsg *)msg completion:(RemoveMsgBlock)block {
    if (msg)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger idx = [_msgList indexOfObject:msg];
        
        if (idx >= 0 && idx < _msgList.count)
        {
            NSInteger preIdx = idx - 1;
            TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
            if (preIdx >= 0 && preIdx < _msgList.count)
            {
                TSIMMsg *preMsg = [_msgList objectAtIndex:preIdx];
                
                if (preMsg.type == TSIMMsgTypeTimeTip)
                {
                    if (idx == _msgList.count - 1)
                    {
                        // 最后两条消息
                        [array addObject:preMsg];
                        [array addObject:msgReal];
                    }
                    else
                    {
                        NSInteger nextIdx = idx + 1;
                        
                        if (nextIdx >= 0 && nextIdx < _msgList.count)
                        {
                            TSIMMsg *nextMsg = [_msgList objectAtIndex:nextIdx];
                            if (nextMsg.type == TSIMMsgTypeTimeTip)
                            {
                                [array addObject:nextMsg];
                                [array addObject:msgReal];
                            }
                            else
                            {
                                [array addObject:msgReal];
                            }
                        }
                    }
                }
                else
                {
                    TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
                    [array addObject:msgReal];
                }
            }
            else
            {
                TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
                [array addObject:msgReal];
            }
        }
        
        if (block)
        {
            __weak TSSafeMutableArray *wcl = _msgList;
            CommonVoidBlock action = ^{
                for (TSIMMsg *removemsg in array)
                {
                    [removemsg remove];
                }
                
                [wcl removeObjectsInArray:array];
            };
            
            
            block(array, YES, action);
        }
        
        return array;
    }
    
    return nil;
}

- (NSArray *)revokeMsg:(TSIMMsg *)msg isRemote:(BOOL)isRemote completion:(RemoveMsgBlock)block {
    if (msg)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        NSInteger idx = [_msgList indexOfObject:msg];
        
        if (idx >= 0 && idx < _msgList.count)
        {
            NSInteger preIdx = idx - 1;
            TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
            if (preIdx >= 0 && preIdx < _msgList.count)
            {
                TSIMMsg *preMsg = [_msgList objectAtIndex:preIdx];
                
                if (preMsg.type == TSIMMsgTypeTimeTip)
                {
                    if (idx == _msgList.count - 1)
                    {
                        // 最后两条消息
                        [array addObject:preMsg];
                        [array addObject:msgReal];
                    }
                    else
                    {
                        NSInteger nextIdx = idx + 1;
                        
                        if (nextIdx >= 0 && nextIdx < _msgList.count)
                        {
                            TSIMMsg *nextMsg = [_msgList objectAtIndex:nextIdx];
                            if (nextMsg.type == TSIMMsgTypeTimeTip)
                            {
                                [array addObject:nextMsg];
                                [array addObject:msgReal];
                            }
                            else
                            {
                                [array addObject:msgReal];
                            }
                        }
                    }
                }
                else
                {
                    TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
                    [array addObject:msgReal];
                }
            }
            else
            {
                TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
                [array addObject:msgReal];
            }
        }
        
        if (block)
        {
            __weak TSSafeMutableArray *wcl = _msgList;
            TSIMMsg *msgReal = [_msgList objectAtIndex:idx];
            NSUInteger index = [wcl indexOfObject:msgReal];
            TSIMMsg *imamsg = [TSIMMsg msgWithRevoked:msgReal.msg.sender];
            [wcl replaceObjectAtIndex:index withObject:imamsg];
            
            for (TSIMMsg *removemsg in array)
            {
                if (removemsg.type == TSIMMsgTypeTimeTip || removemsg.type == TSIMMsgTypeSaftyTip)
                {
                    // 属于自定义的类型，不在IMSDK数据库里面，不能调remove接口
                    continue;
                }
                if (isRemote)
                {
                    block(array, YES, nil);
                }
                else
                {
                    [_conversation revokeMessage:removemsg.msg succ:^{
                        NSLog(@"revoke succ");
                        block(array, YES, nil);
                    } fail:^(int code, NSString *msg) {
                        NSLog(@"revoke fail");
                        NSString *info = [NSString stringWithFormat:@"消息撤回失败,code=%d,msg=%@",code,msg];
//                        [[HUDHelper sharedInstance] tipMessage:info delay:3];
                        block(array, NO, nil);
                    }];
                }
                break;
            }
            
        }
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
