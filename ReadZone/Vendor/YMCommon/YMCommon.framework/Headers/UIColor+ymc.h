//
//  UIColor+ym.h
//  YMCommonFrameWork
//
//  Created by liushilou on 16/12/21.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ymc)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString:(NSString *)color;


/**
 用 RGB 值获取颜色

 @param red 红色（取值 0~255，整数）
 @param green 绿色（取值 0~255，整数）
 @param blue 蓝色（取值 0~255，整数）
 @param alpha 透明度（取值 0~1，浮点数）
 @return 颜色
 */
+ (UIColor *)ym_colorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue alpha:(CGFloat)alpha;

@end
