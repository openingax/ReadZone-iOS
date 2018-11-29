//
//  TSIMAPlatform+Login.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/29.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMAPlatform.h"

@interface TSIMAPlatform (Login)

- (void)login:(TIMLoginParam *)param succ:(TIMLoginSucc)succ fail:(TIMFail)fail;

// 配置进入主界面后的要拉取的数据
- (void)configOnLoginSucc:(TIMLoginParam *)param;

@end
