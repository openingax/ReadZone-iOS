//
//  TSChatBaseTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatBaseTableViewCell.h"
#import "MsgSendingTip.h"

@implementation TSChatBaseTableViewCell

// 只创建，外部统一添加
- (UIView<TSElemSendingAbleView> *)addSendingTips
{
    MsgSendingTip *tip = [[MsgSendingTip alloc] init];
    return tip;
}

// 只创建，外部统一添加
- (UIView<TSElemPickedAbleView> *)addPickedView
{
    return nil;
}

- (void)configContent {
    UIEdgeInsets inset = [_msg contentBackInset];
    
    if (_msg.type == TSIMMsgTypeImage || _msg.type == TSIMMsgTypeVideo) {
        
    } else {
        _contentBack.image = [[UIImage tim_imageWithBundleAsset:@"bubble_gray"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    }
}

- (void)configSendingTips
{
    [super configSendingTips];
    TSIMMsgStatus state = [_msg status];
    [_sendingTipRef setMsgStatus:state];
}

- (void)addC2CCellViews
{
    [super addC2CCellViews];
    [_icon addTarget:self action:@selector(onClickUserIcon) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickUserIcon
{
    [super configSendingTips];
    TSIMMsgStatus state = [_msg status];
    [_sendingTipRef setMsgStatus:state];
}


@end
