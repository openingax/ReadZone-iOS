//
//  TSIMServerViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

/**
 服务层，用于处理登录退出、页面跳转相关的事务
 */

#import "TSTableRefreshViewController.h"
#import "TSManager.h"
#import "TSUserManager.h"

@interface TSIMServerViewController : TSTableRefreshViewController

/**
 留言板登录成功
 */
- (void)didLogin;


/**
 退出留言板
 许多操作需要在退出动作完成前去操作，如把 topViewController 置空，防止内存泄漏
 当前用户如果被踢下线，不能直接调用 dismissViewController，需要调此方法，否则很多服务未退出，造成内存泄漏
 */
- (void)didTIMServerExit;

@end
