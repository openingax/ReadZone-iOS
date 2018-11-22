//
//  TSIMMsg+UITableViewCell.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsg.h"

@interface TSIMMsg (UITableViewCell)

@property (nonatomic, assign) CGFloat showHeightInChat;
@property (nonatomic, assign) CGSize showContentSizeInChat;
@property (nonatomic, strong) NSAttributedString *showChatAttributedText;
//@property (nonatomic, strong) NSAttributedString *showLastMsgAttributedText;
//@property (nonatomic, strong) NSAttributedString *showDraftMsgAttributedText;

@end

