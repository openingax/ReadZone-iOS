//
//  IMALoginParam.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/29.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "IMALoginParam.h"
#import "TSConfig.h"
#import "NSObject+Json.h"
#import "NSString+Common.h"
#import "TSUserManager.h"

@implementation TIMLoginParam (PlatformConfig)

- (IMAPlatformConfig *)config {
    return nil;
}

- (void)saveToLocal {
    // do nothing
}

@end

@implementation IMALoginParam

#define kIMALoginParamUserKey       @"kIMALoginParamUserKey"
#define kDaysInSeconds(x)           (x * 24 * 60 * 60)

- (instancetype)init {
    if (self = [super init]) {
        self.appidAt3rd = kTimIMSdkAppId;
        self.config = [[IMAPlatformConfig alloc] init];
        self.identifier = [TSUserManager shareInstance].account;
        self.userSig = [TSUserManager shareInstance].userSig;
    }
    return self;
}

+ (instancetype)loadFromLocal {
    NSString *userLoginKey = [[NSUserDefaults standardUserDefaults] objectForKey:kIMALoginParamUserKey];
    if (userLoginKey) {
        IMALoginParam *param = [IMALoginParam loadInfo:[IMALoginParam class] withKey:userLoginKey];
        return param;
    } else {
        return [[IMALoginParam alloc] init];
    }
}

- (void)saveToLocal {
    if (self.tokenTime == 0) {
        self.tokenTime = [[NSDate date] timeIntervalSince1970];
    }
    
    if ([self isVailed]) {
        NSString *userIDKey = [NSString stringWithFormat:@"%@_LoginParam", self.identifier];
        [[NSUserDefaults standardUserDefaults] setObject:userIDKey forKey:kIMALoginParamUserKey];
        [IMALoginParam saveInfo:self withKey:userIDKey];
    }
}

- (BOOL)isExpired {
    time_t curTime = [[NSDate date] timeIntervalSince1970];
    BOOL expired = curTime - self.tokenTime > kDaysInSeconds(10);
    return expired;
}

- (BOOL)isVailed {
    return ![NSString isEmpty:self.identifier] && ![NSString isEmpty:self.userSig];
}

@end
