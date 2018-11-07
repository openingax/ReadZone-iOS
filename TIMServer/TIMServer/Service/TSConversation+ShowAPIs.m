//
//  TSConversation+ShowAPIs.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSConversation+ShowAPIs.h"
#import "TSIMMsg.h"

@implementation TSConversation (ShowAPIs)

- (NSString *)lastMsg
{
    if (_lastMessage == nil) {
        [self asyncLoadLocalLastMsg:nil];
    }
    return [_lastMessage msgTip];
}

@end
