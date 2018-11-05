//
//  YMInputBaseViewController.h
//  WaterPurifier
//
//  Created by liushilou on 16/8/4.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMCInputBaseViewController : UIViewController


@property (nonatomic,strong,readonly) UIScrollView *parentScrollView;

//键盘弹出时，偏移量
@property (nonatomic,assign) CGFloat offset;

@end
