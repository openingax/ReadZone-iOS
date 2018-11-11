//
//  YMAlertViewController.h
//  WaterPurifier
//
//  Created by liushilou on 16/11/23.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YMCAlertViewType)
{
  YMCAlertViewTypeMessageOnly,
  YMCAlertViewTypeMessageAndImage
};



@interface YMCAlertViewController : UIViewController

@property (nonatomic,assign) YMCAlertViewType type;

@property (nonatomic,copy) NSString *alertTitle;

@property (nonatomic,strong) NSMutableAttributedString *attributeMessage;

@property (nonatomic,copy) NSString *message;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,copy) NSString *btnTitle;

@property (nonatomic,copy) void (^actionBlock)();


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message action:(void (^)())block;

- (instancetype)initWithTitle:(NSString *)title mutableMessage:(NSMutableAttributedString *)message action:(void (^)())block;

+ (void)showAlertview:(NSString *)message;



@end
