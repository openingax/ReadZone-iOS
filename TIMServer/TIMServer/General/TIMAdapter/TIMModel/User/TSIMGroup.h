//
//  TSIMGroup.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/17.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMUser.h"
#import "IMAUserShowAble.h"

@interface TSIMGroup : TSIMUser <IMAGroupShowAble>
{
@protected
    TIMGroupInfo            *_groupInfo;
    TIMGroupMemberInfo      *_selfGroupInfo;
    NSMutableArray          *_members;
}

@property (nonatomic, readonly) TIMGroupInfo *groupInfo;
@property (nonatomic, readonly) NSMutableArray *members;

- (instancetype)initWithInfo:(TIMGroupInfo *)group;

- (void)changeGroupInfo:(TIMGroupInfo *)info;

- (void)modifySelfGroupNameCard:(NSString *)namecard;

// 是否为我创建的群
- (BOOL)isCreatedByMe;

// 是否为我管理的群
- (BOOL)isManagedByMe;

// 是否为聊天室
- (BOOL)isChatRoom;

// 是否为聊天组
- (BOOL)isChatGroup;

// 是否为公开群
- (BOOL)isPublicGroup;

- (NSString *)selfNamecard;

- (NSString *)receiveMessageOpt;

- (NSString *)groupAddOpt;

@end
