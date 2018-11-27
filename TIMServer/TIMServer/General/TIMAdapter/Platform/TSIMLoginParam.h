//
//  TSIMLoginParam.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/26.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import "TSIMLoginParam.h"
#import "IMAPlatformConfig.h"

@interface TIMLoginParam (PlatformConfig)

//- (TSIMPlatformConfig *)config;
- (void)saveToLocal;

@end

@interface TSIMLoginParam : TIMLoginParam

@property(nonatomic,assign) NSInteger tokenTime;            // 时间戳
//@property(nonatomic,strong) TSIMPlatformConfig *config;     // 用户对应的配置

+ (instancetype)loadFromLocal;

// 保存至本地
- (void)saveToLocal;

// 是否过期
- (BOOL)isExpired;

// 是否有效
- (BOOL)isVailed;

@end
