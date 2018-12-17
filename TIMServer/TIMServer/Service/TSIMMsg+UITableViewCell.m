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
#import "TIMElem+ShowAPIs.h"

@implementation TSIMMsg (UITableViewCell)

#define kCellDefaultMargin 8
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

- (NSAttributedString *)showDraftMsgAttributedText
{
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] init];
    NSInteger loc = 0;
    //    for (int i = 0; i < self.msgDraft.elemCount; i++)
    //    {
    //        TIMElem *e = [self.msgDraft getElem:i];
    //        NSArray *array = [e singleAttachmentOf:self];
    //        for (NSAttributedString *ca in array)
    //        {
    //            [ats appendAttributedString:ca];
    //            // 移动光标
    //            loc += ca.length;
    //        }
    //    }
    return ats;
}

- (NSAttributedString *)showLastMsgAttributedText
{
    //    NSAttributedString *string = objc_getAssociatedObject(self, (__bridge const void *)kIMAMsgShowLastMsgAttributedText);
    //    if (!string)
    //    {
    NSAttributedString *ats = [self loadShowLastMsgAttributedText];
    //        self.showLastMsgAttributedText = ats;
    return ats;
    
    //    }
    //    return string;
}

- (NSAttributedString *)loadShowLastMsgAttributedText
{
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] init];
    NSInteger loc = 0;
    for (int i = 0; i < self.msg.elemCount; i++)
    {
        TIMElem *e = [self.msg getElem:i];
        NSArray *array = [e singleAttachmentOf:self];
        for (NSAttributedString *ca in array)
        {
            [ats appendAttributedString:ca];
            // 移动光标
            loc += ca.length;
        }
    }
    if (ats.string.length == 0)
    {
        return [[NSMutableAttributedString alloc] initWithString:@"..."];
    }
    return ats;
}

- (void)setShowLastMsgAttributedText:(NSAttributedString *)showLastMsgAttributedText
{
    //    objc_setAssociatedObject(self, (__bridge const void *)kIMAMsgShowLastMsgAttributedText, showLastMsgAttributedText, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)msgCellReuseIndentifier
{
    if (_type == TSIMMsgTypeImage) {
        TIMImageElem *elem = (TIMImageElem *)[_msg getElem:0];
        uint32_t uploadId = elem.taskId;
        return [NSString stringWithFormat:@"IMAMsgCell_%d_%d", (int)_type, uploadId];
    } else {
        return [NSString stringWithFormat:@"IMAMsgCell_%d", (int)_type];
    }
}

- (Class)showCellClass
{
    // 目前TIMMessage里面只有一个element，可以这样写
    TIMElem *elem = [_msg getElem:0];
    return [elem showCellClassOf:self];
}

- (UITableViewCell<TSElemAbleCell> *)tableView:(UITableView *)tableView style:(TSElemCellStyle)style indexPath:(NSIndexPath *)indexPath
{
    NSString *reuseid = [self msgCellReuseIndentifier];
    
    TSElemBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    
    if (!cell)
    {
        if (style == TSElemCellStyleC2C)
        {
            cell = [[[self showCellClass] alloc] initWithC2CReuseIdentifier:reuseid];
        }
        else if (style == TSElemCellStyleGroup)
        {
            cell = [[[self showCellClass] alloc] initWithGroupReuseIdentifier:reuseid];
        }
        else
        {
            DebugLog(@"不支持该类型的Cell，请检查代码逻辑");
            NSException *e = [NSException exceptionWithName:@"不支持该类型的Cell" reason:@"不支持该类型的Cell" userInfo:nil];
            @throw e;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (cell == nil)
    {
        DebugLog(@"不支持该类型的Cell，请检查代码逻辑");
        NSException *e = [NSException exceptionWithName:@"不支持该类型的Cell" reason:@"不支持该类型的Cell" userInfo:nil];
        @throw e;
    }
    return cell;
}

- (UIFont *)inputTextFont
{
    return kTimMiddleTextFont;
}

- (UIColor *)inputTextColor
{
    return kBlackColor;
}

- (UIFont *)textFont
{
    return kTimMiddleTextFont;
}
- (UIColor *)textColor
{
    //    if ([self isMineMsg])
    //    {
    //        return kWhiteColor;
    //    }
    //    else
    //    {
    return kBlackColor;
    //    }
}

- (UIFont *)tipFont
{
    return kTimSmallTextFont;
}
- (UIColor *)tipTextColor
{
    //    if ([self isMsgDraft])
    //    {
    //        return kLightGrayColor;
    //    }
    //    return [self isMineMsg] ? self.status == EIMAMsg_SendSucc ? kLightGrayColor : kRedColor : kLightGrayColor;
    return kLightGrayColor;
}

- (NSInteger)contentMaxWidth;
{
    return (NSInteger)(kScreenWidth * 0.6);
}

- (NSInteger)heightInWidth:(CGFloat)width inStyle:(BOOL)isGroup
{
    if (self.showHeightInChat != 0)
    {
        return self.showHeightInChat;
    }
    
    if (self.type == TSIMMsgTypeTimeTip || self.type == TSIMMsgTypeSaftyTip)
    {
        // 时间标签显示20
        self.showHeightInChat = 20;
        return self.showHeightInChat;
    }
    
    CGSize size = [self contentBackSizeInWidth:width];
    
    if (self.type == TSIMMsgTypeGroupTips)
    {
        self.showHeightInChat = size.height;
        return size.height;
    }
    
    if (isGroup && ![self isMineMsg])
    {
        size.height += [self groupMsgTipHeight];
    }
    size.height += kCellDefaultMargin;
    
    CGSize iconSize = [self userIconSize];
    if (size.height < iconSize.height + kCellDefaultMargin)
    {
        size.height = iconSize.height + kCellDefaultMargin;
    }
    
    size.height -= 8;
    if (size.height < 64) {
        size.height = 64;
    }
    
    self.showHeightInChat = size.height;
    return size.height;
}

- (UIEdgeInsets)contentBackInset
{
    
    //    if (self.isMineMsg)
    //    {
    //        return UIEdgeInsetsMake(kDefaultMargin/2 + 1, kDefaultMargin/2, kDefaultMargin/2 + 1, kDefaultMargin + 1);
    //    }
    //    else
    //    {
    //        return UIEdgeInsetsMake(kDefaultMargin/2 + 1, kDefaultMargin + 2, kDefaultMargin/2 + 1, kDefaultMargin/2 + 1);
    if (self.type == TSIMMsgTypeText) {
        return UIEdgeInsetsMake(28, 20, 8, 20);
    } else if (self.type == TSIMMsgTypeImage || self.type == TSIMMsgTypeVideo) {
        return UIEdgeInsetsMake(30, kCellDefaultMargin + 7, 9, kCellDefaultMargin/2 + 5);
    } else {
        return UIEdgeInsetsMake(28, kCellDefaultMargin + 2, 6, kCellDefaultMargin/2 + 1);
    }
    
    //    }
}

- (NSInteger)pickedViewWidth
{
    return 44;
}
- (CGSize)userIconSize
{
    return CGSizeMake(44, 44);
}
- (NSInteger)sendingTipWidth
{
    return 24;
}

- (NSInteger)groupMsgTipHeight
{
    return 20;
}

- (NSInteger)horMargin
{
    return kCellDefaultMargin;
}

// 当正在Picked的时候
- (CGSize)contentBackSizeInWidth:(CGFloat)width
{
    NSInteger horMargin = [self horMargin];
    CGSize size = CGSizeMake(width, HUGE_VALF);
    if (self.isPicked)
    {
        // 在勾选状态
        size.width -= horMargin + [self pickedViewWidth] + horMargin + [self sendingTipWidth] + horMargin + horMargin + [self userIconSize].width + horMargin;
        size = [self contentSizeInWidth:size.width];
    }
    else
    {
        // 在非勾选状态下
        if ([[_msg getElem:0] isKindOfClass:[TIMTextElem class]]) {
            TIMTextElem *textElem = (TIMTextElem *)[_msg getElem:0];
            if (textElem.text.length > 15) {
                
            }
        }
        
        size.width -= horMargin + [self sendingTipWidth] + horMargin + horMargin + [self userIconSize].width + horMargin;
        size = [self contentSizeInWidth:size.width];
    }
    
    if (self.type == TSIMMsgTypeGroupTips)
    {
        return size;
    }
    
    
    UIEdgeInsets inset = [self contentBackInset];
    size.width += inset.left + inset.right;
    size.height += inset.top + inset.bottom;
    
    return size;
}

// 只算内容的size
- (CGSize)contentSizeInWidth:(CGFloat)width
{
    if (self.showContentSizeInChat.width != 0)
    {
        return self.showContentSizeInChat;
    }
    
    NSInteger max = [self contentMaxWidth];
    if (width > max)
    {
        width = max;
    }
    CGFloat h = 0;
    CGFloat w = 0;
    
    if ([self isMultiMsg])
    {
        self.showContentSizeInChat = [self multiContentSizeInWidth:width];
        return self.showContentSizeInChat;
    }
    else
    {
        // 本质上只有一个element
        // 目前大部份都是只有一个elemment，后面有多个element的时候再作处理
        for (int i = 0; i < [_msg elemCount]; i++)
        {
            TIMElem *elem = [_msg getElem:i];
            CGSize size = [elem sizeInWidth:width atMsg:self];
            h += size.height;
            if (w < size.width)
            {
                w = size.width;
            }
        }
    }
    
    self.showContentSizeInChat = CGSizeMake(w, h);
    return self.showContentSizeInChat;
}


// 用于计算显示的文本高度
static TSChatTextView *kSharedTextView = nil;

- (CGSize)multiContentSizeInWidth:(CGFloat)width
{
    if (!kSharedTextView)
    {
        kSharedTextView = [[TSChatTextView alloc] init];
    }
    
    // 设置一个最大值
    kSharedTextView.frame = CGRectMake(0, 0, width, 1024 * 100);
    
    [kSharedTextView showMessage:self];
    
    CGRect rect = [kSharedTextView.layoutManager usedRectForTextContainer:kSharedTextView.textContainer];
    
    return rect.size;
}

- (void)updateElem:(TIMElem *)elem attachmentChanged:(NSTextAttachment *)att
{
    // 更新产变更的att
    self.showChatAttributedText = [self loadShowChatAttributedText];
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMAMSG_ChangedNotification object:self];
}

- (void)prepareChatForReuse
{
    self.showChatAttributedText = nil;
}

@end
