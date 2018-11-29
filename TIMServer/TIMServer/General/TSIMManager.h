//
//  TSIMManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 退出留言板的通知
#define kTIMServerExitNoti @"kTIMServerExitNoti"

@interface TSIMManager : NSObject

+ (instancetype)shareInstance;

@property(nonatomic,strong) UINavigationController *navigationController;
@property(nonatomic,strong) UIViewController *topViewController;

@end
