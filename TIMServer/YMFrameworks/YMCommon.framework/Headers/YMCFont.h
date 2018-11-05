//
//  YMCFont.h
//  YMCommon
//
//  Created by 刘世楼 on 2018/9/19.
//  Copyright © 2018年 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//字体大小
#define YMC_FONTSIZE_NAV_TITLE 17
#define YMC_FONTSIZE_TITLE 16
#define YMC_FONTSIZE_CONTENT_BIG 14
#define YMC_FONTSIZE_CONTENT_MIDDLE 12
#define YMC_FONTSIZE_CONTENT_SMALL 10

//字体颜色
//品牌色
#define YMC_COLOR_BRAND @"#00A3B4"
//辅助色-翡翠绿
#define YMC_COLOR_LIGHTGREEN @"#79CAD3"
//辅助色-墨色
#define YMC_COLOR_BLACK @"#404040"
//辅助色-淡墨色
#define YMC_COLOR_LIGHTBLACK1 @"#808080"
//辅助色-淡墨色
#define YMC_COLOR_LIGHTBLACK2 @"#999999"
//辅助色-淡墨色
#define YMC_COLOR_LIGHTBLACK3 @"#B6B5BE"
//点缀色-红
#define YMC_COLOR_RED @"#FF4444"
//点缀色-黄
#define YMC_COLOR_YELLOW @"#FFB644"
//点缀色-灰
#define YMC_COLOR_GRAY @"#F3F3F3"
//线条颜色
#define YMC_COLOR_LINE @"#E3E2EE"
//背景色
#define YMC_COLOR_BACKGROUD @"#F7F7F7"


typedef NS_ENUM(NSInteger, YMCFontType) {
    YMCFontTypeKlight,
    YMCFontTypeKMedium,
    YMCFontTypeOutside,
    YMCFontTypeGBKBold,
    YMCFontTypeGBKLight,
    YMCFontTypeGBKThin
};


@interface YMCFont : NSObject

/**
 字体使用

 @param type 字体类型YMCFontType
 @param size 字体大小
 @return UIFont
 */
+ (UIFont *)fontOfType:(YMCFontType)type size:(CGFloat)size;

@end
