//
//  AppDelegate.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/3.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RZBaseNavigationController.h"
#import "RZLoginViewController.h"
#import "RZRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic,strong) UIWindow *window;
@property(nonatomic,strong) UIViewController *keyVC;
@property(nonatomic,strong) RZBaseNavigationController *navigationController;
@property(nonatomic,strong) RZLoginViewController *loginViewController;
@property(nonatomic,strong) RZRootViewController *rootViewController;

+ (instancetype)shared;

@end

