//
//  TSElemBaseTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSElemBaseTableViewCell.h"

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
    _icon.layer.cornerRadius = 16;
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

- (void)relayoutC2CCellViews
{
    CGRect rect = self.contentView.bounds;
    NSInteger hor = [_msg horMargin];
    NSInteger ver = kDefaultMargin/2;
    if ([_msg isMineMsg])
    {
        if (self.isEditing)
        {
            if (_pickedViewRef)
            {
                [_pickedViewRef sizeWith:CGSizeMake([_msg pickedViewWidth], rect.size.height)];
                [_pickedViewRef alignParentLeftWithMargin:hor];
                [_pickedViewRef relayoutFrameOfSubViews];
            }
        }
        
        [_icon sizeWith:[_msg userIconSize]];
        [_icon alignParentRightWithMargin:hor];
        [_icon alignParentBottomWithMargin:ver];
        
        CGSize contentBackSize = [_msg contentBackSizeInWidth:rect.size.width];
        [_contentBack sizeWith:contentBackSize];
        [_contentBack layoutToLeftOf:_icon margin:hor];
        [_contentBack alignParentBottomWithMargin:ver];
        
        
        UIEdgeInsets inset = [_msg contentBackInset];
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
            NSInteger width = [_msg sendingTipWidth];
            [_sendingTipRef sizeWith:CGSizeMake(width, rect.size.height)];
            [_sendingTipRef layoutToLeftOf:_contentBack margin:hor];
            [_sendingTipRef relayoutFrameOfSubViews];
        }
    }
    else
    {
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
        [_contentBack sizeWith:contentBackSize];
        [_contentBack layoutToRightOf:_icon margin:hor];
        [_contentBack alignTop:_icon];
        
        
        UIEdgeInsets inset = [_msg contentBackInset];
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
        
    }
}

@end
