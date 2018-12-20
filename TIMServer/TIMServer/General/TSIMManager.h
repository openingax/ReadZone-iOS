//
//  TSIMManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSIMManager : NSObject

+ (instancetype)shareInstance;

/**
 保存当前显示的 topViewController，供录音时显示提示窗口用
 注意：在退出留言板时，需要把 topViewController 置为 nil，否则 topViewController 无法释放造成内存泄漏
 */
@property(nonatomic,strong) UIViewController *topViewController;

@end
