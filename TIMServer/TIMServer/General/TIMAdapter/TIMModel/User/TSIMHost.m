//
//  TSIMHost.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/26.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMHost.h"

@implementation TSIMHost

- (void)asyncProfile
{
    __weak TSIMHost *ws = self;
    [[TIMFriendshipManager sharedInstance] getSelfProfile:^(TIMUserProfile *selfProfile) {
        DebugLog(@"Get Self Profile Succ");
        ws.profile = selfProfile;
    } fail:^(int code, NSString *err) {
        DebugLog(@"Fail:-->code=%d,msg=%@,fun=%s", code, err,__func__);
    }];
}

- (BOOL)isMe:(TSIMUser *)user {
    return [self.userId isEqualToString:user.userId];
}

- (void)setLoginParm:(TIMLoginParam *)loginParm
{
    _loginParam = loginParm;
    [_loginParam saveToLocal];
}

- (NSString *)userId
{
    return _profile ? _profile.identifier : _loginParam.identifier;
}
- (NSString *)icon
{
    return nil;
}
- (NSString *)remark
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}
- (NSString *)name
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}
- (NSString *)nickName
{
    return ![NSString isEmpty:_profile.nickname] ? _profile.nickname : _profile.identifier;
}

@end
