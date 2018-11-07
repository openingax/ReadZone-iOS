//
//  TSUserManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSUserManager.h"

static NSString * const kTSUserAccoutKey = @"ts_user_account_key";
static NSString * const kTSUserSigKey = @"ts_user_account_key";

@implementation TSUserManager

+ (instancetype)shareInstance {
    static TSUserManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _account = [defaults objectForKey:kTSUserAccoutKey];
        _userSig = [defaults objectForKey:kTSUserSigKey];
    }
    
    return self;
}

- (void)saveUserAccount:(NSString *)account userSig:(NSString *)sig {
    _account = account;
    _userSig = sig;
    
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kTSUserAccoutKey];
    [[NSUserDefaults standardUserDefaults] setObject:sig forKey:kTSUserSigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {
    return YES;
}

@end
