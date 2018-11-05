//
//  YMNoNetView.h
//  yunSale
//
//  Created by liushilou on 16/12/2.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YMCRequestStatus) {
    YMCRequestSuccess,
    YMCRequestError,
    YMCRequestNetError,
    YMCRequestTokenOuttime,
    YMCRequestCancle,
    YMCRequestNoData, //没有数据，展示重新加载按钮
    YMCRequestNoDataAndNoBtn, //没有数据，并且不展示重新加载按钮
    YMCRequestNoDataAndRefreshBtn, //没有数据，展示刷新按钮
};


#define YM_NOSEARCHDATA_TEXT @"抱歉，没有符合条件的数据哦"
#define YM_NOMOREDATA_TEXT @"没有更多数据"

@interface YMCNetErrorView : UIView

@property (nonatomic,assign) BOOL show;

@property (nonatomic,assign) YMCRequestStatus erorType;

@property (nonatomic,copy) NSString *message;


- (instancetype)initWithActionBlock:(void (^)())block;

@end
