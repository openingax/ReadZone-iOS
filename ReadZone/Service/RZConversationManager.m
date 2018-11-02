//
//  RZConversationManager.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZConversationManager.h"
#import "RZIMMsg.h"

@implementation RZConversationChangedNotifyItem

- (instancetype)initWithType:(RZConversationChangedNotifyType)type {
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
    return [NSString stringWithFormat:@"RZConversationChangedNotification_%d", (int)_type];
}

@end



@implementation RZConversationManager

- (instancetype)init {
    if (self = [super init]) {
        _conversationList = [[RZSafeSetArray alloc] init];
    }
    return self;
}

- (void)releaseChattingConversation {
    
}

- (RZConversation *)chatWith:(RZIMUser *)user {
    TIMConversation *conv = nil;
    if ([user isC2CType]) {
        conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[user userId]];
    }
    
    if (conv) {
        RZConversation *temp = [[RZConversation alloc] initWithConversation:conv];
        NSInteger index = [_conversationList indexOfObject:temp];
        if (index >= 0 && index < _conversationList.count) {
            RZConversation *ret = [_conversationList objectAtIndex:index];
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
        RZIMMsg *imMsg = [RZIMMsg msgWithMsg:msg];
        
        TIMConversation *conv = [msg getConversation];
        BOOL isSystemMsg = [imMsg isSystemMsg];
        
        if (isSystemMsg) {
            
        }
        
        for (int i = 0; i < [_conversationList count]; i++) {
            RZConversation *imConv = [_conversationList objectAtIndex:i];
            NSString *imConvReceiver = [imConv receiver];
            
            if ([imConv type] == [conv getType] && ([imConvReceiver isEqualToString:[conv getReceiver]])) {
                if (imConv == _chattingConversation) {
                    
                    imConv.lastMessage = imMsg;
                    [_chattingConversation onReceiveNewMessage:imMsg];
                    
                } else {
                    
                }
            }
        }
    }
}

@end
