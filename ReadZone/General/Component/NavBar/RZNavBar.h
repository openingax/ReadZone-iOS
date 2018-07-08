//
//  RZNavBar.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZNavBarItem.h"

typedef void (^Callback)(RZNavBarItem *backItem);

@interface RZNavBar : UIView

@property(nonatomic,copy) NSArray *leftBarItems;
@property(nonatomic,copy) NSArray *rightBarItems;
@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,readonly,strong) RZNavBarItem *backItem;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,strong) UIImage *backgroundImg;
@property(nonatomic,assign) BOOL hidenBackItem;
@property(nonatomic,copy) Callback touchBackItemBlock;
@property(nonatomic,strong) UIImageView *backgroundImgView;
@property(nonatomic,assign) CGFloat contentViewCenterXOffset;         // default 0

+ (RZNavBar *)navBarWithTouchBackItemBlock:(Callback)touchBackItemBlock;

@end

@interface RZNavBar (Background)

- (void)setBackgroundTransparent;

@end
