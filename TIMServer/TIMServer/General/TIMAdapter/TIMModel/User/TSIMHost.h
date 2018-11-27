//
//  TSIMHost.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/26.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMUser.h"
#import "TSDebugMarco.h"
#import "NSString+Common.h"
#import "TSIMLoginParam.h"

@interface TSIMHost : TSIMUser

@property(nonatomic,strong) TIMLoginParam *loginParam;
@property(nonatomic,strong) TIMUserProfile *profile;

// 同步自己的个人资料
- (void)asyncProfile;
// 判断用户是不是自己
- (BOOL)isMe:(TSIMUser *)user;

@end
