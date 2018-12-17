//
//  TSIMGroup.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/17.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMGroup.h"
#import <IMGroupExt/IMGroupExt.h>

// 讨论组
@implementation TSIMGroup

#define kPrivateGroupType   @"Private"

// 公开群
#define kPublicGroupType    @"Public"

// 聊天室
#define kChatRoomGroupType  @"ChatRoom"


- (instancetype)initWithInfo:(TIMGroupInfo *)group
{
    if (self = [super init])
    {
        _groupInfo = group;
        [self initSelfGroupInfo];
    }
    return self;
}

- (void)initSelfGroupInfo
{
    __weak TSIMGroup *ws = self;
    [[TIMGroupManager sharedInstance] getGroupSelfInfo:self.groupId succ:^(TIMGroupMemberInfo *selfInfo) {
        [ws changeSelfGroupInfo:selfInfo];
    } fail:^(int code, NSString *msg) {
        DebugLog(@"code = %d,msg = %@", code, msg);
    }];
}

- (NSString *)selfNamecard
{
    if (_selfGroupInfo)
    {
        return _selfGroupInfo.nameCard;
    }
    else
    {
        return @"";
    }
}

//由于目前版本GetGroupInfo接口返回的 TIMGroupInfo 中 selfInfo为空，所以更新群资料时，需要判断，selfInfo若为空，则保留原来的selfInfo
- (void)changeGroupInfo:(TIMGroupInfo *)info
{
    if (info.selfInfo)
    {
        _groupInfo = info;
    }
    else
    {
        TIMGroupSelfInfo *selfInfo =  _groupInfo.selfInfo;
        _groupInfo = info;
        _groupInfo.selfInfo = selfInfo;
    }
}

- (void)changeSelfGroupInfo:(TIMGroupMemberInfo *)info
{
    _selfGroupInfo = info;
}

- (void)modifySelfGroupNameCard:(NSString *)namecard
{
    _selfGroupInfo.nameCard = namecard;
}

- (BOOL)isChatRoom
{
    return [_groupInfo.groupType isEqualToString:kChatRoomGroupType];
    
}
- (BOOL)isChatGroup
{
    return [_groupInfo.groupType isEqualToString:kPrivateGroupType];
}
- (BOOL)isPublicGroup
{
    return [_groupInfo.groupType isEqualToString:kPublicGroupType];
}

- (BOOL)isCreatedByMe
{
    return NO;
//    return [_groupInfo.owner isEqualToString:[[TSIMAPlatform sharedInstance].host userId]];
}

- (BOOL)isManagedByMe
{
//等待接口支持
return _groupInfo.selfInfo.role == TIM_GROUP_MEMBER_ROLE_ADMIN;
}

#pragma - mark overwrite IMAUser方法

- (NSString *)groupId
{
    return [self userId];
}

- (NSString *)userId
{
    if (_groupInfo)
    {
        return [_groupInfo group];
    }
    else
    {
        return [super userId];
    }
}

- (void)setUserId:(NSString *)userId
{
    if (_groupInfo)
    {
        return [_groupInfo setGroup:userId];
    }
    else
    {
        [super setUserId:userId];
    }
}

- (NSString *)icon
{
    if (_groupInfo)
    {
        return [_groupInfo faceURL];
    }
    else
    {
        return [super icon];
    }
}

- (void)setIcon:(NSString *)icon
{
    if (_groupInfo)
    {
        return [_groupInfo setFaceURL:icon];
    }
    else
    {
        return [super setIcon:icon];
    }
}

- (NSString *)nickName
{
    if (_groupInfo)
    {
        return _groupInfo.groupName;
    }
    else
    {
        return [super nickName];
    }
}

- (void)setNickName:(NSString *)nickName
{
    if (_groupInfo)
    {
        return [_groupInfo setGroupName:nickName];
    }
    else
    {
        return [super setNickName:nickName];
    }
}

- (NSString *)remark
{
    if (_groupInfo)
    {
        return _groupInfo.groupName;
    }
    else
    {
        return [super remark];
    }
}

- (void)setRemark:(NSString *)remark
{
    if (_groupInfo)
    {
        return [_groupInfo setGroupName:remark];
    }
    else
    {
        return [super setRemark:remark];
    }
}

- (NSInteger)memberCount
{
    return _groupInfo.memberNum;
}

- (BOOL)isC2CType
{
    return NO;
}

- (BOOL)isGroupType
{
    return YES;
}

@end
