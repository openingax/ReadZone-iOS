//
//  YMTextField.h
//  WaterPurifier
//
//  Created by liushilou on 16/11/18.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YMCTextFieldType)
{
  YMCTextFieldTypeActionSelect,
  YMCTextFieldTypeActionPassword,
  YMCTextFieldTypeActionRound,
};

typedef NS_ENUM(NSInteger,YMCTextFieldStatus)
{
  YMCTextFieldStatusError,
  YMCTextFieldStatusNormal
};


@interface YMCTextField : UITextField

//旋转标志
@property (nonatomic,assign) BOOL open;

@property (nonatomic,strong) UIImage *selectedIcon;



- (instancetype)initWithType:(YMCTextFieldType)type icon:(UIImage *)icon action:(void (^)())block;

//旋转图标
-(void)rotateIcon;

-(void)changeStatus:(YMCTextFieldStatus)status;




@end
