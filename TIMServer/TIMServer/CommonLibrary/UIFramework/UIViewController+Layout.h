//
//  UIViewController+Layout.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Layout)

- (void)layoutOnViewDidAppear;

- (void)layoutSubviewsFrame;

- (void)addOwnViews;

- (void)configOwnViews;

@end

NS_ASSUME_NONNULL_END
