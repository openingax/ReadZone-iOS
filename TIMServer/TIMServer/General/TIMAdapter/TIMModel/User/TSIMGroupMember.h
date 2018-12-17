//
//  TSIMGroupMember.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/17.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMUser.h"

@interface TSIMGroupMember : TSIMUser
{
@protected
    TIMGroupMemberInfo *_memberInfo;
}

@property(nonatomic,strong) TIMGroupMemberInfo *memberInfo;

- (instancetype)initWithMemberInfo:(TIMGroupMemberInfo *)user;

- (BOOL)isGroupOwner;
- (BOOL)isGroupAdmin;
- (BOOL)isNormalMember;

- (BOOL)isSilence;

@end
