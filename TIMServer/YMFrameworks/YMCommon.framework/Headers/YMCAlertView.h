//
//  YMAlertView.h
//  yunSale
//
//  Created by liushilou on 16/11/10.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMCNetErrorView.h"

@class YMCNetErrorView;

@interface YMCAlertView : NSObject

+ (void)showMessage:(NSString *)message;

+ (void)showHubInView:(UIView *)view message:(NSString *)message;

+ (void)showNetErrorInView:(UIView *)view type:(YMCRequestStatus)type message:(NSString *)message actionBlock:(void (^)())block;

+ (void)removeNetErrorInView:(UIView *)view;

@end
