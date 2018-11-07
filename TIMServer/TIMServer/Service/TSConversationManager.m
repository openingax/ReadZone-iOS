//
//  TSConversationManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSConversationManager.h"
#import "TSIMMsg.h"

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
    
}

- (void)asyncRefreshConversationList {
    
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
        if ([imMsg isSystemMsg]) {
            return;
        }
    }
}

@end
