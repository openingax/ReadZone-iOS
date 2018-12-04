//
//  TSIMUser.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMUser.h"
#import "NSString+Common.h"

@implementation TSIMUser

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

- (NSURL *)showIconUrl {
    NSString *icon = [self icon];
    if ([NSString isEmpty:icon]) {
        return nil;
    }
    
    return [NSURL URLWithString:icon];
}

- (NSString *)showTitle {
    return ![NSString isEmpty:self.remark] ? self.remark : ![NSString isEmpty:self.nickName] ? self.nickName : self.userId;
}

- (BOOL)isC2CType {
//    if ([[self userId] hasPrefix:@"viot"]) {
//        return NO;
//    }
    return YES;
}

- (BOOL)isGroupType {
//    if ([[self userId] hasPrefix:@"viot"]) {
//        return YES;
//    }
    return NO;
}

- (BOOL)isSystemType {
    return NO;
}

- (BOOL)isEqual:(id)object {
    BOOL equal = [super isEqual:object];
    
    if (!equal) {
        if ([object isKindOfClass:[TSIMUser class]]) {
            TSIMUser *user = (TSIMUser *)object;
            
            if ((user.isC2CType && self.isC2CType) || (user.isGroupType && self.isGroupType)) {
                equal = [self.userId isEqualToString:user.userId];
            }
        }
    }
    
    return equal;
}

@end
