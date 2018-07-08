//
//  UIImage+RZ.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RZ)

//模糊图片
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//图片透明度
+ (UIImage *)alphaImage:(UIImage*)image withAlpha:(CGFloat)alpha;

@end
