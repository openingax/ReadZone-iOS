//
//  TSIMMsg+UITableViewCell.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsg.h"
#import "TSElemAbleCell.h"
#import "TSElemBaseTableViewCell.h"
#import "TSChatTextView.h"
#import "TSIMAdapter.h"

@interface TSIMMsg (UITableViewCell)

@property (nonatomic, assign) CGFloat showHeightInChat;
@property (nonatomic, assign) CGSize showContentSizeInChat;
@property (nonatomic, strong) NSAttributedString *showChatAttributedText;
@property (nonatomic, strong) NSAttributedString *showLastMsgAttributedText;
@property (nonatomic, strong) NSAttributedString *showDraftMsgAttributedText;

- (UITableViewCell<TSElemAbleCell> *)tableView:(UITableView *)tableView style:(TSElemCellStyle)style indexPath:(NSIndexPath *)indexPath;

- (Class)showCellClass;

- (UIFont *)inputTextFont;

- (UIColor *)inputTextColor;

- (UIFont *)textFont;

- (UIColor *)textColor;

- (UIFont *)tipFont;

- (UIColor *)tipTextColor;

- (NSInteger)contentMaxWidth;

// IMAMsg 显示的高度
- (NSInteger)heightInWidth:(CGFloat)width inStyle:(BOOL)isGroup;

// 各控件间的水平间距
- (NSInteger)horMargin;

// 根据具体情况content在气泡背景里的inset
- (UIEdgeInsets)contentBackInset;

// 选择控件宽度
- (NSInteger)pickedViewWidth;

// 用户头像大小
- (CGSize)userIconSize;

// 发送消息的宽度
- (NSInteger)sendingTipWidth;

// 群消息时，显示对方名称的高度
- (NSInteger)groupMsgTipHeight;

// 只算内容的size
- (CGSize)contentSizeInWidth:(CGFloat)width;

// 带背景图的Size
- (CGSize)contentBackSizeInWidth:(CGFloat)width;

- (void)updateElem:(TIMElem *)elem attachmentChanged:(NSTextAttachment *)att;

- (NSAttributedString *)loadShowLastMsgAttributedText;

- (void)prepareChatForReuse;

@end

