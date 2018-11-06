//
//  TSManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSManager : NSObject


/**
 显示留言板视图控制器

 @param params 参数
 @param controller 宿主控制器
 */
- (void)showMsgVCWithParams:(NSDictionary *)params controller:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
