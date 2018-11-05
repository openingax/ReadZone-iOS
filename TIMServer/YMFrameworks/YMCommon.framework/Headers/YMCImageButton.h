//
//  YMImageButton.h
//  yunSale
//
//  Created by liushilou on 16/11/15.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCImageButton : UIButton



- (id)initWithTitle:(NSString *)title image:(UIImage *)image;

- (id)initWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle image:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
