//
//  TSElemAbleCell.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSIMMsg.h"

typedef NS_ENUM(NSUInteger, TSElemCellStyle) {
    TSElemCellStyleC2C,
    TSElemCellStyleGroup
};

@class TSIMMsg;
@protocol TSElemAbleCell <NSObject>

@required

// 构选方法
- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier;

// 配置以及显示IMAMsg
@property(nonatomic,weak) TSIMMsg *msg;
- (void)configWith:(TSIMMsg *)msg;

// 显示Menu
- (BOOL)canShowMenu;
- (BOOL)canShowMenuOnTouchOf:(UIGestureRecognizer *)ges;
- (void)showMenu;
- (NSArray *)showMenuItems;
@end

@protocol TSElemPickedAbleView <NSObject>

@property(nonatomic,assign) BOOL selected;

@end

@protocol TSElemSendingAbleView <NSObject>

- (void)setMsgStatus:(NSInteger)status;

@end


