//
//  YMButton.h
//  WaterPurifier
//
//  Created by liushilou on 16/5/20.
//  Copyright © 2016年 Viomi. All rights reserved.
//


//#warning 还没想好怎么弄～，先放着吧。忙其他的～

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YMCButtonType)
{
  //因为按钮样式目前还没有确定、甚至确定以后也可能会改，并没有特定的名字能形容特定的样式，所以以1、2、3～等来表示
  YMCButtonTypeCircleCorner,
  YMCButtonTypeSelect,
  YMCButtonTypeBorder,
  YMCButtonTypeRoundBorder,
};

@interface YMCButton : UIButton

@property (nonatomic,strong) UIImage *selectedImage;
@property (nonatomic,strong) UIImage *unSelectedImage;




- (id)initWithFrame:(CGRect)frame style:(YMCButtonType)type;

- (id)initWithStyle:(YMCButtonType)type;


@end
