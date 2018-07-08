//
//  RZNavBar.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZNavBar.h"

@implementation RZNavBar
@synthesize contentView = _contentView;

- (instancetype)init
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, kNavTotalHeight);
        
        _backItem = [RZNavBarItem navBarItemWithType:RZNavBarItemTypeBack];
        [_backItem addTarget:self action:@selector(toucheBackItem:) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor colorWithHex:kColorNavTitle];
        
        _backgroundImgView = [[UIImageView alloc] init];
        _backgroundImgView.image = [UIImage imageNamed:@"nav_bar_bg"];
        
        [self addSubview:_backgroundImgView];
        [self addSubview:_backItem];
        [self addSubview:_titleLabel];
        [self makeConstraints];
    }
    return self;
}

+ (RZNavBar *)navBarWithTouchBackItemBlock:(Callback)touchBackItemBlock
{
    RZNavBar *bar = [[RZNavBar alloc] init];
    bar.touchBackItemBlock = touchBackItemBlock;
    return bar;
}

#pragma mark - Constraints

- (void)updateConstraints
{
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kNavTotalHeight);
    }];
    [super updateConstraints];
}

- (void)makeConstraints
{
    
    [_backItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
    }];
    
    [_backgroundImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    UIView *leftView = _backItem;
    if (_hidenBackItem)
    {
        leftView = nil;
    }
    
    for (UIView *item in _leftBarItems)
    {
        NSInteger index = [_leftBarItems indexOfObject:item];
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backItem);
            
            if (index == 0 && self.hidenBackItem)
            {
                make.left.equalTo(self);
            }
            else
            {
                make.left.equalTo(leftView.mas_right);
            }
        }];
        [item updateConstraints];
        leftView = item;
    }
    
    UIView *rightView = nil;
    for (NSInteger index = _rightBarItems.count - 1; index > -1; index--)
    {
        UIView *item = [_rightBarItems objectAtIndex:index];
        [item mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backItem);
            
            if (rightView)
            {
                make.right.equalTo(rightView.mas_left);
            }
            else
            {
                make.right.equalTo(self);
            }
        }];
        [item updateConstraints];
        rightView = item;
    }
    
    [self.contentView sizeToFit];
    self.contentView.center = CGPointMake(kScreenWidth / 2, 42);
    if ([self.contentView isEqual:_titleLabel])
    {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backItem);
            make.centerX.priorityLow().equalTo(self);
            if (leftView)
            {
                make.left.greaterThanOrEqualTo(leftView.mas_right);
            }
            
            if (rightView)
            {
                make.right.lessThanOrEqualTo(rightView.mas_left);
            }
            
        }];
    }
    else
    {
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backItem);
            make.centerX.equalTo(self).offset(self.contentViewCenterXOffset);
            make.width.mas_equalTo(self.contentView.frame.size.width);
            make.height.mas_equalTo(self.contentView.frame.size.height);
            make.width.lessThanOrEqualTo(self);
            make.height.lessThanOrEqualTo(@44);
        }];
    }
    
    //防止返回按钮被contentviewdangzhu
    [self bringSubviewToFront:_backItem];
}

#pragma mark - IBAction
- (void)toucheBackItem:(RZNavBarItem *)sender
{
    if (_touchBackItemBlock)
    {
        _touchBackItemBlock(sender);
    }
}

#pragma mark - Getter and Setter

- (void)setHidenBackItem:(BOOL)hidenBackItem
{
    _hidenBackItem = hidenBackItem;
    _backItem.hidden = hidenBackItem;
}

- (void)setLeftBarItems:(NSArray *)leftBarItems
{
    for (UIView *item in _leftBarItems)
    {
        [item removeFromSuperview];
    }
    
    _leftBarItems = leftBarItems;
    for (UIView *item in _leftBarItems)
    {
        [self addSubview:item];
    }
    
    [self makeConstraints];
}

- (void)setRightBarItems:(NSArray *)rightBarItems
{
    for (UIView *item in _rightBarItems)
    {
        [item removeFromSuperview];
    }
    _rightBarItems = rightBarItems;
    
    for (UIView *item in _rightBarItems)
    {
        [self addSubview:item];
    }
    
    [self makeConstraints];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}

- (void)setBackgroundImg:(UIImage *)backgroundImg
{
    _backgroundImg = backgroundImg;
    _backgroundImgView.image = _backgroundImg;
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    if (![self.subviews containsObject:_contentView]) {
        [self addSubview:_contentView];
    }
    [self makeConstraints];
}

//默认contentview 就是titlelabel
- (UIView *)contentView
{
    if (_contentView)
    {
        return _contentView;
    }
    else
    {
        return _titleLabel;
    }
}

@end

@implementation RZNavBar (Background)

- (void)setBackgroundTransparent
{
    self.backgroundColor = [UIColor clearColor];
    self.backgroundImgView.hidden = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
}

@end
