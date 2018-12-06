//
//  TSIMServerViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

/* 服务层，只用于初始化 SDK 与登录相关的事务 */

#import "TSTableRefreshViewController.h"
#import "TSManager.h"
#import "TSUserManager.h"

@interface TSIMServerViewController : TSTableRefreshViewController

- (void)didLogin;
- (void)didTIMServerExit;

@end
