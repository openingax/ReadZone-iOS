//
//  TSRichChatTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSRichChatTableViewCell.h"

@implementation TSRichChatTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_msg prepareChatForReuse];
}

// 只创建，外部统一添加
//- (UIView *)addElemContent
//{
//    _textView = [[ChatTextView alloc] init];
//    _textView.backgroundColor = kClearColor;
//    return _textView;
//}

- (void)configContent
{
    [super configContent];
    
//    CGSize showSize = [_msg showContentSizeInChat];
//    _textView.bounds = CGRectMake(0, 0, showSize.width, showSize.height);
//    [_textView showMessage:_msg];
}

@end
