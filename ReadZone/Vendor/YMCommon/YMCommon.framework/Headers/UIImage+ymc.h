//
//  UIImage+ym.h
//  YMCommonFrameWork
//
//  Created by liushilou on 16/12/21.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ymc)

//根据颜色、尺寸创建图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
