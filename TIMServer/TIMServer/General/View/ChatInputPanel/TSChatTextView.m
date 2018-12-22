//
//  TSChatTextView.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatTextView.h"

@implementation TSChatTextView

- (instancetype)init
{
    if (self = [super init])
    {
        // 只用于显示
        self.editable = NO;
        self.scrollEnabled = NO;
        self.selectable = NO;
//        self.contentInset = UIEdgeInsetsZero;
//        self.textContainerInset = UIEdgeInsetsZero;
//        self.scrollIndicatorInsets = UIEdgeInsetsZero;
//        self.textContainer.lineFragmentPadding = 0;
    }
    return self;
}

- (void)clearAll
{
    self.text = nil;
    self.attributedText = nil;
    
    // 添空内部的图片
    for (UIView* subView in self.subviews)
    {
        if ([subView isKindOfClass:[UIImageView class]])
        {
            [subView removeFromSuperview];
        }
    }
}

- (BOOL)enableLongPressed
{
    return NO;
}

- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    //Prevent zooming but not panning
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
    {
        gestureRecognizer.enabled = [self enableLongPressed];
    }
    [super addGestureRecognizer:gestureRecognizer];
}

- (void)showMessage:(TSIMMsg *)msg
{
    [self clearAll];
    [self.textStorage insertAttributedString:msg.showChatAttributedText atIndex:self.selectedRange.location];
    _msgRef = msg;
    self.selectedRange = NSMakeRange(self.selectedRange.location + 1, self.selectedRange.length);
}

// 作用是屏蔽UITextView长按，双击等显示菜单问题
- (BOOL)shouldPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return [self shouldPerformAction:action withSender:sender];
}

- (BOOL)canBecomeFirstResponder
{
    return [self shouldPerformAction:nil withSender:nil];
}

@end
