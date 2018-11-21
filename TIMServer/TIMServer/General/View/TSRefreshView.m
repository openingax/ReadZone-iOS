//
//  TSRefreshView.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSRefreshView.h"

@implementation TSHeadRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.refreshHeight = kDefaultCellHeight;
    }
    return self;
}

- (void)addOwnViews {
    _loading = [[UILabel alloc] init];
    _loading.textAlignment = NSTextAlignmentCenter;
    _loading.textColor = RGB(145, 145, 145);
    _loading.font = [UIFont systemFontOfSize:12];
    [self addSubview:_loading];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_indicator];
    
    self.backgroundColor = RGB(230, 230, 230);
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    rect.origin.y += rect.size.height - self.refreshHeight;
    rect.size.height = self.refreshHeight;
    
    _loading.frame = rect;
    _indicator.frame = CGRectInset(rect, (rect.size.width - 30)/2, (rect.size.height - 30)/2);
}

- (void)willLoading
{
    if (_state == TSRefreshLoadingStateWillLoading)
    {
        return;
    }
    
    _loading.hidden = NO;
    _indicator.hidden = YES;
    _loading.text = @"下拉即可刷新";
    _state = TSRefreshLoadingStateWillLoading;
}

- (void)releaseLoading
{
    if (_state == TSRefreshLoadingStateReleaseLoading)
    {
        return;
    }
    _loading.hidden = NO;
    _indicator.hidden = YES;
    _loading.text = @"松开即可更新";
    
    _state = TSRefreshLoadingStateReleaseLoading;
}

- (void)loading
{
    if (_state == TSRefreshLoadingStateLoading)
    {
        return;
    }
    _loading.hidden = YES;
    _indicator.hidden = NO;
    
    [_indicator startAnimating];
    _state = TSRefreshLoadingStateLoading;
}
- (void)loadingOver
{
    if (_state == TSRefreshLoadingStateLoadingOver)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_loading.hidden = YES;
        if ([self->_indicator isAnimating])
        {
            [self->_indicator stopAnimating];
            self->_indicator.hidden = YES;
        }
        self->_state = TSRefreshLoadingStateLoadingOver;
    });
}

@end


@implementation TSFootRefreshView

- (void)willLoading
{
    if (_state == TSRefreshLoadingStateWillLoading)
    {
        return;
    }
    _loading.hidden = NO;
    _indicator.hidden = YES;
    _loading.text = @"上拉即可刷新";
    _state = TSRefreshLoadingStateWillLoading;
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    rect.size.height = self.refreshHeight;
    
    _loading.frame = rect;
    _indicator.frame = CGRectInset(rect, (rect.size.width - 30)/2, (rect.size.height - 30)/2);
}

@end
