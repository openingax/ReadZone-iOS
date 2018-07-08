//
//  RZNavBarItem.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RZNavBarItemType) {
    RZNavBarItemTypeNormal = 0,     // 普通类型
    RZNavBarItemTypeBack,           // 返回按钮
};

@interface RZNavBarItem : UIButton

@property(nonatomic,assign) CGFloat itemWidth;      // default 44.f;
@property(nonatomic,assign) RZNavBarItemType itemType;
@property(nonatomic,strong) UIImage *normalImg;
@property(nonatomic,strong) UIImage *selectedImg;

+ (instancetype)navBarItemWithType:(RZNavBarItemType)itemType;
+ (instancetype)navBarItemTitle:(NSString *)title normalImg:(UIImage *)normalImg selectedImg:(UIImage *)selectedImg;
+ (instancetype)navBarItemTitle:(NSString *)title;

@end
