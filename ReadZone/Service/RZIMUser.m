//
//  RZIMUser.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZIMUser.h"

@implementation RZIMUser

- (instancetype)initWithUserId:(NSString *)userId {
    if (self = [super init]) {
        self.userId = userId;
    }
    return self;
}

- (instancetype)initWithUserInfo:(TIMUserProfile *)userProfile {
    if (self = [super init]) {
        self.userId = userProfile.identifier;
        self.nickName = userProfile.nickname;
        self.remark = userProfile.remark;
        self.icon = userProfile.faceURL;
    }
    return self;
}

#pragma mark -

- (NSURL *)showIconURL {
    NSString *icon = [self icon];
    if ([NSString isEmptyString:icon]) {
        return nil;
    }
    
    return [NSURL URLWithString:icon];
}

- (NSString *)showTitle {
    return ![NSString isEmptyString:self.remark] ? self.remark : ![NSString isEmptyString:self.nickName] ? self.nickName : self.userId;
}

- (BOOL)isC2CType {
    return YES;
}

- (BOOL)isGroupType {
    return NO;
}

- (BOOL)isSystemType {
    return NO;
}

- (BOOL)isEqual:(id)object {
    BOOL equal = [super isEqual:object];
    
    if (!equal) {
        if ([object isKindOfClass:[RZIMUser class]]) {
            RZIMUser *user = (RZIMUser *)object;
            
            if ((user.isC2CType && self.isC2CType) || (user.isGroupType && self.isGroupType)) {
                equal = [self.userId isEqualToString:user.userId];
            }
        }
    }
    
    return equal;
}

@end
