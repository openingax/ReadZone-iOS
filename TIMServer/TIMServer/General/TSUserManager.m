//
//  TSUserManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSUserManager.h"

static NSString * const kTSUserDeviceIDKey = @"ts_user_device_id_key";
static NSString * const kTSUserAccoutKey = @"ts_user_account_key";
static NSString * const kTSUserSigKey = @"ts_user_sig_key";
static NSString * const kTSReceiverKey = @"ts_receiver_key";

static NSString * const kTSGroupIDKey = @"ts_group_id_key";

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
        _deviceID = [defaults objectForKey:kTSUserDeviceIDKey];
        _account = [defaults objectForKey:kTSUserAccoutKey];
        _userSig = [defaults objectForKey:kTSUserSigKey];
        _receiver = [defaults objectForKey:kTSReceiverKey];
        _groupID = [defaults objectForKey:kTSGroupIDKey];
    }
    
    return self;
}

- (void)saveDeviceID:(NSString *)deviceID {
    _deviceID = deviceID;
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:kTSUserDeviceIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveAccount:(NSString *)account {
    _account = account;
    
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kTSUserAccoutKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveUserSig:(NSString *)userSig {
    _userSig = userSig;
    
    [[NSUserDefaults standardUserDefaults] setObject:userSig forKey:kTSUserSigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveUserAccount:(NSString *)account userSig:(NSString *)sig receiver:(NSString *)receiver {
    _account = account;
    _userSig = sig;
    _receiver = receiver;
    
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kTSUserAccoutKey];
    [[NSUserDefaults standardUserDefaults] setObject:sig forKey:kTSUserSigKey];
    [[NSUserDefaults standardUserDefaults] setObject:_receiver forKey:kTSReceiverKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveGroupID:(NSString *)groupID {
    _groupID = groupID;
    
    [[NSUserDefaults standardUserDefaults] setObject:groupID forKey:kTSGroupIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {
    return YES;
}

- (void)deleteUserSig {
    _userSig = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kTSUserSigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
