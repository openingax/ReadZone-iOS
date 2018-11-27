//
//  TSConversationManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSConversationManager.h"
#import "TSIMMsg.h"
#import <IMMessageExt/IMMessageExt.h>
#import "CustomElemCmd.h"
#import "TSChatHeaders.h"

@interface TSConversationManager () <TIMMessageListener>

@end

@implementation TSConversationChangedNotifyItem

- (instancetype)initWithType:(TSConversationChangedNotifyType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSNotification *)changedNotification {
    NSNotification *notify = [NSNotification notificationWithName:[self notificaionName] object:nil];
    return notify;
}

- (NSString *)notificaionName {
    return [NSString stringWithFormat:@"TSConversationChangedNotification_%d", (int)_type];
}

@end

@implementation TSConversationManager

- (instancetype)init {
    if (self = [super init]) {
        _conversationList = [[TSSafeSetArray alloc] init];
    }
    return self;
}

- (void)releaseChattingConversation {
    [_chattingConversation releaseConversation];
    _chattingConversation = nil;
}

- (void)asyncConversationList {
    [self asyncUpdateConversationList];
}

- (void)asyncUpdateConversationList {
    NSInteger unRead = 0;
    NSArray *conversationList = [[TIMManager sharedInstance] getConversationList];
    
    for (TIMConversation *conversation in conversationList) {
        TSConversation *conv = nil;
        if ([conversation getType] == TIM_SYSTEM) {
            continue;
        } else {
            conv = [[TSConversation alloc] initWithConversation:conversation];
        }
        
        if (conv) {
            [_conversationList addObject:conv];
        }
        
        if (_chattingConversation && [_chattingConversation isEqual:conv]) {
            [conv copyConversationInfo:_chattingConversation];
            _chattingConversation = conv;
        } else {
            if (conv) {
                unRead += [conversation getUnReadMessageNum];
            }
        }
    }
    
    [self asyncUpdateConversationListComplete];
}

- (void)asyncRefreshConversationList {
    
}

- (void)asyncUpdateConversationListComplete
{
    [self updateOnLocalMsgComplete];
}

- (void)updateOnAsyncLoadContactComplete
{
    // 通知更新界面
    TSConversationChangedNotifyItem *item = [[TSConversationChangedNotifyItem alloc] initWithType:TSConversationChangedNotifyTypeSyncLocalConversation];
    if (_conversationChangedCompletion)
    {
        _conversationChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
}

- (void)updateOnLocalMsgComplete
{
    // 更新界面
    TSConversationChangedNotifyItem *item = [[TSConversationChangedNotifyItem alloc] initWithType:TSConversationChangedNotifyTypeSyncLocalConversation];
    if (_conversationChangedCompletion)
    {
        _conversationChangedCompletion(item);
    }
    [[NSNotificationQueue defaultQueue] enqueueNotification:[item changedNotification] postingStyle:NSPostWhenIdle];
}

- (TSConversation *)chatWith:(TSIMUser *)user {
    TIMConversation *conv = nil;
    if ([user isC2CType]) {
        conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[user userId]];
    }
    
    if (conv) {
        TSConversation *temp = [[TSConversation alloc] initWithConversation:conv];
        NSInteger index = [_conversationList indexOfObject:temp];
        if (index >= 0 && index < _conversationList.count) {
            TSConversation *ret = [_conversationList objectAtIndex:index];
            _chattingConversation = ret;
            _chattingConversation.lastMessage = _chattingConversation.lastMessage;
            return ret;
        }
        
        _chattingConversation = temp;
        return temp;
    }
    return nil;
}

- (void)onNewMessage:(NSArray *)msgs {
    for (TIMMessage *msg in msgs) {
        TSIMMsg *imMsg = [TSIMMsg msgWithMsg:msg];
        TIMConversation *conv = [msg getConversation];
        
        if ([imMsg isSystemMsg]) {
            return;
        }
        
//        BOOL updateSucc = NO;
        
        for (int i = 0; i < [_conversationList count]; i++) {
            TSConversation *imaconv = [_conversationList objectAtIndex:i];
            NSString *imaconvReceiver = [imaconv receiver];
            if (imaconv.type == [conv getType] && [imaconvReceiver isEqualToString:[conv getReceiver]]) {
                
                NSLog(@"SA;DFJSADKADKAS;DFKA;DFJKA;DFKSA;D\n%ld", (long)imaconv.type);
                
                if ([imaconv.receiver isEqualToString:_chattingConversation.receiver]) {
                
                    //如果是c2c会话，则更新“对方正在输入...”状态
                    BOOL isInputStatus = NO;
                    
                    if (!msg.isSelf) {
                        
                        if (_chattingConversation.type == TIM_C2C) {
                            
                            // 过滤掉聊天输入状态的消息
                            int elemCount = [imMsg.msg elemCount];
                            for (int i = 0; i < elemCount; i++) {
                                TIMElem *elem = [msg getElem:i];
                                CustomElemCmd *elemCmd = [self isOnlineMsg:elem];
                                
                                if (elemCmd) {
                                    isInputStatus = YES;
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserInputStatus object:elemCmd];
                                }
                            }
                        }
                        
                        if (!isInputStatus) {
                            imaconv.lastMessage = imMsg;
                            [_chattingConversation onReceiveNewMessage:imMsg];
                        }
                    }
                }
            }
        }
    }
}

- (CustomElemCmd *)isOnlineMsg:(TIMElem *) elem
{
    if ([elem isKindOfClass:[TIMCustomElem class]])
    {
        CustomElemCmd *elemCmd = [CustomElemCmd parseCustom:(TIMCustomElem *)elem];
        if (elemCmd)
        {
            return elemCmd;
        }
    }
    return nil;
}

@end
