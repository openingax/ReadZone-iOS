//
//  TSChatBaseTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatBaseTableViewCell.h"

@implementation TSChatBaseTableViewCell

// 只创建，外部统一添加
- (UIView<TSElemSendingAbleView> *)addSendingTips
{
    return nil;
}

// 只创建，外部统一添加
- (UIView<TSElemPickedAbleView> *)addPickedView
{
    return nil;
}


- (void)configContent {
    UIEdgeInsets inset = [_msg contentBackInset];
    if ([_msg isMineMsg])
    {
        _contentBack.image = [[UIImage imageNamed:@"bubble_blue"] resizableImageWithCapInsets:inset];
    }
    else
    {
        _contentBack.image = [[UIImage imageNamed:@"bubble_gray"] resizableImageWithCapInsets:inset];
    }
}

- (void)configSendingTips
{
    
}

- (void)addC2CCellViews
{
    [super addC2CCellViews];
    [_icon addTarget:self action:@selector(onClickUserIcon) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickUserIcon
{
    
}


@end
