//
//  TSElemBaseTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSElemBaseTableViewCell.h"
#import "TSUserManager.h"

@implementation TSElemBaseTableViewCell

- (void)dealloc {
    [_msgKVO unobserveAll];
}

+ (UIFont *)defaultNameFont {
    return kTimSmallTextFont;
}

+ (UIFont *)defaultTextFont {
    return kTimMiddleTextFont;
}

- (BOOL)canBecomeFirstResponder {
    return [self canShowMenu];
}

- (BOOL)canShowMenu {
    return YES;
}

- (BOOL)canShowMenuOnTouchOf:(UIGestureRecognizer *)ges {
    CGPoint p = [ges locationInView:_contentBack];
    BOOL contain = CGRectContainsPoint(_contentBack.bounds, p);
    return contain;
}

- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor = kClearColor;
        _cellStyle = TSElemCellStyleC2C;
        [self addC2CCellViews];
    }
    
    return self;
}

- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kClearColor;
        self.backgroundColor = kClearColor;
        _cellStyle = TSElemCellStyleGroup;
        [self addGroupCellViews];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    _pickedViewRef.hidden = !editing;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self relayoutFrameOfSubViews];
}

- (void)relayoutFrameOfSubViews {
    switch (_cellStyle) {
        case TSElemCellStyleC2C: {
            
            [self relayoutC2CCellViews];
            
        } break;
            
        case TSElemCellStyleGroup: {
            
            [self relayoutGroupCellViews];
            
        } break;
            
        default:
            break;
    }
}

- (void)addC2CCellViews
{
    _icon = [[UIButton alloc] init];
    _icon.layer.cornerRadius = 3.f;
    _icon.layer.masksToBounds = YES;
    [self.contentView addSubview:_icon];
    
    _contentBack = [[UIImageView alloc] init];
    _contentBack.userInteractionEnabled = YES;
    [self.contentView addSubview:_contentBack];
    _elemContentRef = [self addElemContent];
    if (_elemContentRef)
    {
        [_contentBack addSubview:_elemContentRef];
    }
    
    _sendingTipRef = [self addSendingTips];
    if (_sendingTipRef)
    {
        [self.contentView addSubview:_sendingTipRef];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resendMsg)];
        [_sendingTipRef addGestureRecognizer:tap];
    }
    
    _pickedViewRef = [self addPickedView];
    if (_pickedViewRef)
    {
        _pickedViewRef.hidden = YES;
        [self.contentView addSubview:_sendingTipRef];
    }
}

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    return nil;
}


// 只创建，外部统一添加
- (UIView<TSElemSendingAbleView> *)addSendingTips
{
    return nil;
}

// 只创建，外部统一添加
- (UIView *)addPickedView
{
    return nil;
}

- (void)addGroupCellViews
{
    [self addC2CCellViews];
    
    _remarkTip = [[UILabel alloc] init];
    _remarkTip.textColor = kLightGrayColor;
    _remarkTip.font = [TSElemBaseTableViewCell defaultNameFont];
    [self.contentView addSubview:_remarkTip];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *)obj;
            imgView.image = nil;
        }
    }];
}

- (void)relayoutC2CCellViews
{
    CGRect rect = self.contentView.bounds;
    NSInteger hor = [_msg horMargin];
    NSInteger ver = 6;
//    if ([_msg isMineMsg])
//    {
//        if (self.isEditing)
//        {
//            if (_pickedViewRef)
//            {
//                [_pickedViewRef sizeWith:CGSizeMake([_msg pickedViewWidth], rect.size.height)];
//                [_pickedViewRef alignParentLeftWithMargin:hor];
//                [_pickedViewRef relayoutFrameOfSubViews];
//            }
//        }
//
//        [_icon sizeWith:[_msg userIconSize]];
//        [_icon alignParentRightWithMargin:hor];
//        [_icon alignParentBottomWithMargin:ver];
//
//        CGSize contentBackSize = [_msg contentBackSizeInWidth:rect.size.width];
//        contentBackSize.height -= kTableViewCellBubbleMarginTop;
//        [_contentBack sizeWith:contentBackSize];
//        [_contentBack layoutToLeftOf:_icon margin:hor];
//        [_contentBack alignParentBottomWithMargin:ver];
//
//
//        UIEdgeInsets inset = [_msg contentBackInset];
//        inset.top -= kTableViewCellBubbleMarginTop;
//        contentBackSize.width -= inset.left + inset.right;
//        contentBackSize.height -= inset.top + inset.bottom;
//
//        if (_elemContentRef)
//        {
//            [_elemContentRef sizeWith:contentBackSize];
//            [_elemContentRef alignParentLeftWithMargin:inset.left];
//            [_elemContentRef alignParentTopWithMargin:inset.top];
//            [_elemContentRef relayoutFrameOfSubViews];
//        }
//
//        if (_sendingTipRef)
//        {
//            NSInteger width = [_msg sendingTipWidth];
//            [_sendingTipRef sizeWith:CGSizeMake(width, rect.size.height)];
//            [_sendingTipRef layoutToLeftOf:_contentBack margin:hor];
//            [_sendingTipRef relayoutFrameOfSubViews];
//        }
//    }
//    else
//    {
        // 对方的C2C消息
        
        [_icon sizeWith:[_msg userIconSize]];
        [_icon alignParentTopWithMargin:ver];
        
        if (_pickedViewRef && !_pickedViewRef.hidden)
        {
            [_pickedViewRef sizeWith:CGSizeMake([_msg pickedViewWidth], rect.size.height)];
            [_pickedViewRef alignParentLeftWithMargin:hor];
            [_pickedViewRef relayoutFrameOfSubViews];
            
            [_icon layoutToRightOf:_pickedViewRef margin:hor];
        }
        else
        {
            [_icon alignParentLeftWithMargin:hor];
        }
        
        CGSize contentBackSize = [_msg contentBackSizeInWidth:rect.size.width];
        contentBackSize.height -= kTableViewCellBubbleMarginTop;
        [_contentBack sizeWith:contentBackSize];
        [_contentBack layoutToRightOf:_icon margin:hor];
        [_contentBack alignTop:_icon];
        
#warning handler contentBackInset
        UIEdgeInsets inset = [_msg contentBackInset];
        inset.top -= kTableViewCellBubbleMarginTop;
        contentBackSize.width -= inset.left + inset.right;
        contentBackSize.height -= inset.top + inset.bottom;
        
        if (_elemContentRef)
        {
            [_elemContentRef sizeWith:contentBackSize];
            [_elemContentRef alignParentLeftWithMargin:inset.left];
            [_elemContentRef alignParentTopWithMargin:inset.top];
            [_elemContentRef relayoutFrameOfSubViews];
        }
        
        if (_sendingTipRef)
        {
            //            _sendingTipRef.hidden = YES;
            NSInteger width = [_msg sendingTipWidth];
            [_sendingTipRef sizeWith:CGSizeMake(width, rect.size.height)];
            [_sendingTipRef layoutToRightOf:_contentBack margin:hor];
            [_sendingTipRef relayoutFrameOfSubViews];
        }
//    }
}

- (void)relayoutGroupCellViews
{
    CGRect rect = self.contentView.bounds;
    NSInteger hor = [_msg horMargin];
    //    NSInteger ver = 6;
//    if ([_msg isMineMsg])
//    {
//        // 与C2C消息一致
//        [self relayoutC2CCellViews];
//    }
//    else
//    {
        // 对方的Group消息
        [_icon sizeWith:[_msg userIconSize]];
        [_icon alignParentTopWithMargin:24];
        
        if (_pickedViewRef && !_pickedViewRef.hidden)
        {
            [_pickedViewRef sizeWith:CGSizeMake([_msg pickedViewWidth], rect.size.height)];
            [_pickedViewRef alignParentLeftWithMargin:hor];
            [_pickedViewRef relayoutFrameOfSubViews];
            
            [_icon layoutToRightOf:_pickedViewRef margin:hor];
        }
        else
        {
            [_icon alignParentLeftWithMargin:hor];
        }
        
        [_remarkTip sizeWith:CGSizeMake(rect.size.width, [_msg groupMsgTipHeight])];
        [_remarkTip alignTop:_icon];
        [_remarkTip layoutToRightOf:_icon margin:hor];
        [_remarkTip scaleToParentRightWithMargin:hor];
        
        CGSize contentBackSize = [_msg contentBackSizeInWidth:rect.size.width];
        contentBackSize.height -= kTableViewCellBubbleMarginTop;
        [_contentBack sizeWith:contentBackSize];
        [_contentBack layoutToRightOf:_icon margin:hor];
        [_contentBack layoutBelow:_remarkTip margin:2];
//        [_contentBack alignParentBottomWithMargin:ver];
        
#warning handler contentBackInset
        UIEdgeInsets inset = [_msg contentBackInset];
        inset.top -= kTableViewCellBubbleMarginTop;
        contentBackSize.width -= inset.left + inset.right;
        contentBackSize.height -= inset.top + inset.bottom;
        
        if (_elemContentRef)
        {
            [_elemContentRef sizeWith:contentBackSize];
            [_elemContentRef alignParentLeftWithMargin:inset.left];
            [_elemContentRef alignParentTopWithMargin:inset.top];
            [_elemContentRef relayoutFrameOfSubViews];
        }
        
        if (_sendingTipRef)
        {
//            _sendingTipRef.hidden = YES;
            NSInteger width = [_msg sendingTipWidth];
            [_sendingTipRef sizeWith:CGSizeMake(width, _contentBack.size.height)];
            [_sendingTipRef alignTop:_contentBack];
            [_sendingTipRef layoutToRightOf:_contentBack margin:hor];
            [_sendingTipRef relayoutFrameOfSubViews];
        }
//    }
}

- (void)configKVO
{
    [_msgKVO unobserveAll];
    
    if ([_msg isMineMsg])
    {
        __weak TSElemBaseTableViewCell *ws = self;
        if (!_msgKVO)
        {
            _msgKVO = [FBKVOController controllerWithObserver:self];
        }
        [_msgKVO observe:_msg keyPath:@"status" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
            [ws configSendingTips];
        }];
    }
    else
    {
        _msgKVO = nil;
    }
    
    
}

- (void)configWith:(TSIMMsg *)msg {
    _msg = msg;
    
    [self configKVO];
    
    TSIMUser *user = nil;
    if ([_msg isMineMsg]) {
        user = [TSIMAPlatform sharedInstance].host;
    } else {
        user = [_msg getSender];
    }
    
    [_msg getSender];
    
    [_icon sd_setImageWithURL:[user showIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage tim_imageWithBundleAsset:@"default_user"]];
    
    if (_remarkTip) {
//        _remarkTip.hidden = !([_msg isGroupMsg] && ![msg isMineMsg]);
//        _remarkTip.hidden = ![_msg isGroupMsg];
        _remarkTip.hidden = NO;
        _remarkTip.font = [_msg tipFont];
        _remarkTip.textColor = [_msg tipTextColor];
        _remarkTip.text = [user showTitle];
    }
    
    [self configContent];
    
    if (_elemContentRef) {
        [self configElemContent];
    }
    
    if (_sendingTipRef) {
        [self configSendingTips];
    }
}

- (void)configContent {
    
}

- (void)configElemContent
{
    
}

- (void)configSendingTips
{
    _sendingTipRef.hidden = ![_msg isMineMsg];
}

- (void)resendMsg {
    if (_msg.status == TSIMMsgStatusSendFail) {
        
        /*
         [18-12-19 15:18:12.36][DEBUG][qr_task.cc:54][AddEvent][IMCore]add event: eventId=2, code=114000, desc=init Transaction failed, start=1545203892006, end=1545203892036
         
         图片无法重新发送，报 114000 的错误，怀疑是退出聊天时图片保存失败
         */
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重发该消息？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"重发" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kIMAMSG_ResendNotification object:_msg];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:confirmAction];
        [alert addAction:cancelAction];
        [[TSIMManager shareInstance].topViewController  presentViewController:alert animated:YES completion:nil];
    }
}

- (void)showMenu {
    NSArray *showMenus = [self showMenuItems];
    if (showMenus.count) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:showMenus];
        [menu update];
        [menu setTargetRect:_contentBack.frame inView:self.contentView];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (NSArray *)showMenuItems
{
    NSMutableArray *array = [NSMutableArray array];
    
    UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItem:)];
    [array addObject:deleteItem];
    
    
    
    if ([_msg.msg isSelf])
    {
        NSTimeInterval msgTime = [NSDate currentTimestamp] - [_msg.msg.timestamp timeIntervalSince1970]*1000;
        // 如果消息发送时间超过2分钟，不显示撤回按钮
        if ((msgTime/1000) < 120) {
            UIMenuItem *revokeItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeItem:)];
            [array addObject:revokeItem];
        }
    }
    
    if (_msg.status == TSIMMsgStatusSendFail)
    {
        UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:@"重发" action:@selector(resendItem:)];
        [array addObject:resendItem];
    }
    
    return array;
}

- (void)revokeItem:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMAMSG_RevokeNotification object:_msg];
}

- (void)deleteItem:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMAMSG_DeleteNotification object:_msg];
}

- (void)resendItem:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kIMAMSG_ResendNotification object:_msg];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL can = ((action == @selector(deleteItem:)) || (action == @selector(resendItem:)) || (action == @selector(revokeItem:)));
    return can;
}

@end
