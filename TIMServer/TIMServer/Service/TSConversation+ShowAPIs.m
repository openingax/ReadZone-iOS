//
//  TSConversation+ShowAPIs.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSConversation+ShowAPIs.h"
#import "TSIMMsg.h"
#import "TSIMMsg+UITableViewCell.h"
#import "TSUserManager.h"

@implementation TSConversation (ShowAPIs)

- (Class)showCellClass {
    return nil;
}

- (NSInteger)showHeight {
    return 65;
}

- (NSString *)showReuseIndentifier {
    return @"IMAConversation_ReuseIndentifier";
}

- (NSString *)showTitle {
//    NSString *receive = [_conversation getReceiver];
//    TIMConversationType type = self.type;
//    TSIMUser *user = nil;

    return @"";
}

- (NSString *)lastMsg
{
    if (_lastMessage == nil) {
        [self asyncLoadLocalLastMsg:nil];
    }
    return [_lastMessage msgTip];
}

- (NSAttributedString *)lastAttributedMsg {
    if (_lastMessage == nil) {
        [self asyncLoadLocalLastMsg:nil];
    }
    return [_lastMessage showLastMsgAttributedText];
}

@end
