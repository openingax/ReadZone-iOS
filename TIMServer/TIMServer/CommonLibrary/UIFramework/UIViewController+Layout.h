//
//  UIViewController+Layout.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (AsChild)

- (void)setAsChild:(BOOL)asChild;

- (BOOL)asChild;

- (void)setChildSize:(CGSize)childSize;

- (CGSize)childSize;

@end

@interface UIViewController (Layout)

// 界面进入时重新布局
- (void)layoutOnViewWillAppear;

- (void)layoutSubviewsFrame;

- (void)layoutOnIPhone;

- (void)layoutOnIPadInPortrait;

- (void)layoutOnIPadInLandScape;

- (void)addOwnViews;

- (void)configOwnViews;


@end

//@interface UIViewController (DeviceListChangeNotify)
//
//- (void)addDeviceListChangeObserver;
//- (void)onDeviceListChanged;
//
//@end

@interface UITabBarController (Layout)

@end
