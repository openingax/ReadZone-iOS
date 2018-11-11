//
//  YMScreenAdapter.h
//  WaterPurifier
//
//  Created by liushilou on 16/5/19.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YMSPACE_AROUND 24
#define YMSPACE_AROUND_MID 26
#define YMSPACE_AROOUND_BIG 28

#define YMFONTSIZE_TITLE 28
#define YMFONTSIZE_MID 26
#define YMFONTSIZE_DETAILS 24



@interface YMCScreenAdapter : NSObject


//在640的基础上计算当前机型的尺寸 (完全按比例)
+ (CGFloat)sizeBy640:(CGFloat)size;

//在640的基础上计算当前机型的尺寸 (完全按比例,取整)
+ (CGFloat)intergersizeBy640:(CGFloat)size;

//在750的基础上计算当前机型的尺寸 (完全按比例)
+ (CGFloat)sizeBy750:(CGFloat)size;
//在750的基础上计算当前机型的尺寸 (完全按比例,取整)
+ (CGFloat)intergerSizeBy750:(CGFloat)size;

//按比例计算，640的字体会偏小:用于字体或某些特殊的情况(640时*1.2)
+ (CGFloat)fontsizeBy750:(CGFloat)size;


//在1080的基础上计算当前机型的尺寸 (界面尺寸、字体尺寸都OK)
+ (CGFloat)sizeBy1080:(CGFloat)size;

+ (CGFloat)fontsizeBy1080:(CGFloat)size;


//除去状态栏和导航栏的高度后的高度
+ (CGFloat)contentHeight:(CGFloat)navheight;





@end
