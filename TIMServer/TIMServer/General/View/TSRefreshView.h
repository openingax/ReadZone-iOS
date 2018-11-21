//
//  TSRefreshView.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseView.h"
#import "TSRefreshAbleView.h"

typedef NS_ENUM(NSInteger, TSRefreshLoadingState) {
    TSRefreshLoadingStateLoadingOver,
    TSRefreshLoadingStateWillLoading,
    TSRefreshLoadingStateReleaseLoading,
    TSRefreshLoadingStateLoading
};

@interface TSHeadRefreshView : TSBaseView <TSRefreshAbleView>
{
@protected
    UILabel                 *_loading;
    UIActivityIndicatorView *_indicator;
    
@protected
    TSRefreshLoadingState _state;
}

@property (nonatomic, assign) NSInteger refreshHeight;
@property (nonatomic, readonly) TSRefreshLoadingState state;

@end

@interface TSFootRefreshView : TSHeadRefreshView

@end
