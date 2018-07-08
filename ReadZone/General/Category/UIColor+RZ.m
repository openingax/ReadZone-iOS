//
//  UIColor+RZ.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "UIColor+RZ.h"

@implementation UIColor (RZ)

/**
 *  十六进制的颜色值转换成rgb的颜色值
 *
 *  @param hexColor 十六进制的字符串
 *
 *  @return 颜色值
 */
+ (UIColor *) colorWithHex:(NSString *)hexColor
{
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red green:green blue:blue];
}

+ (UIColor *) colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha
{
    // 转换成标准16进制数
    //    [color replaceCharactersInRange:[color rangeOfString:@"#" ] withString:@"0x"];
    // 十六进制字符串转成整形。
    long colorLong = strtoul([hexColor cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    // 通过位与方法获取三色值
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B = colorLong & 0x0000FF;
    //string转color
    UIColor *wordColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
    return wordColor;
}

+ (UIColor *) colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

+ (UIColor *)rz_colorwithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

@end
