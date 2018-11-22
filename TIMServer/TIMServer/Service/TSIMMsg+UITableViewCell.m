//
//  TSIMMsg+UITableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsg+UITableViewCell.h"
#import <objc/runtime.h>
#import "TIMElem+ChatAttachment.h"

@implementation TSIMMsg (UITableViewCell)

//@dynamic showDraftMsgAttributedText;

static NSString *const kIMAMsgShowHeightInChat = @"kIMAMsgShowHeightInChat";
static NSString *const kIMAMsgShowContentSizeInChat = @"kIMAMsgShowContentSizeInChat";
static NSString *const kIMAMsgShowChatAttributedText = @"kIMAMsgShowChatAttributedText";

- (CGFloat)showHeightInChat
{
    NSNumber *num = objc_getAssociatedObject(self, (__bridge const void *)kIMAMsgShowHeightInChat);
    return [num floatValue];
}

- (void)setShowHeightInChat:(CGFloat)showHeightInChat
{
    objc_setAssociatedObject(self, (__bridge const void *)kIMAMsgShowHeightInChat, @(showHeightInChat), OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)showContentSizeInChat
{
    NSValue *num = objc_getAssociatedObject(self, (__bridge const void *)kIMAMsgShowContentSizeInChat);
    return [num CGSizeValue];
}

- (void)setShowContentSizeInChat:(CGSize)showContentSizeInChat
{
    objc_setAssociatedObject(self, (__bridge const void *)kIMAMsgShowContentSizeInChat, [NSValue valueWithCGSize:showContentSizeInChat], OBJC_ASSOCIATION_RETAIN);
}

- (NSAttributedString *)showChatAttributedText
{
    NSAttributedString *string = objc_getAssociatedObject(self, (__bridge const void *)kIMAMsgShowChatAttributedText);
    if (!string)
    {
        NSAttributedString *ats = [self loadShowChatAttributedText];
        self.showChatAttributedText = ats;
        return ats;
        
    }
    return string;
}

- (void)setShowChatAttributedText:(NSAttributedString *)showChatAttributedText
{
    objc_setAssociatedObject(self, (__bridge const void *)kIMAMsgShowChatAttributedText, showChatAttributedText, OBJC_ASSOCIATION_RETAIN);
}

- (NSAttributedString *)loadShowChatAttributedText
{
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] init];
    NSInteger loc = 0;
    for (int i = 0; i < self.msg.elemCount; i++)
    {
        TIMElem *e = [self.msg getElem:i];
        NSArray *array = [e chatAttachmentOf:self];
        for (NSAttributedString *ca in array)
        {
            [ats appendAttributedString:ca];
            // 移动光标
            loc += ca.length;
        }
    }
    return ats;
}

@end
