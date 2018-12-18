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

//- (void)onPicked:(MenuButton *)btn
//{
//    btn.selected = !btn.selected;
//    _msg.isPicked = btn.selected;
//}

- (void)configContent {
    UIEdgeInsets inset = [_msg contentBackInset];
//    if ([_msg isMineMsg])
//    {
//        _contentBack.image = [[UIImage imageWithBundleAsset:@"bubble_blue"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
//    }
//    else
//    {
//    if ([self isKindOfClass:[TSChatVideoTableViewCell class]] || [self isKindOfClass:[TSChatImageTableViewCell class]]) {
//        _contentBack.image = [[UIImage imageWithBundleAsset:@"bubble_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 8, 20) resizingMode:UIImageResizingModeStretch];
//    } else {
        _contentBack.image = [[UIImage imageWithBundleAsset:@"bubble_gray"] resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
//    }
//    }
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
