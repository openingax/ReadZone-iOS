//
//  RZUserManager.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/26.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZUserManager.h"

static NSString * const kRZUserAccount = @"rz_user_account";
static NSString * const kRZUserPassword = @"rz_user_password";
static NSString * const kRZUserSig = @"rz_user_sig";

@implementation RZUserManager

+ (RZUserManager *)shareInstance {
    static RZUserManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (id)init {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _account = [defaults objectForKey:kRZUserAccount];
        _password = [defaults objectForKey:kRZUserPassword];
        _sig = [defaults objectForKey:kRZUserSig];
    }
    
    return self;
}

- (void)saveUserAccout:(NSString *)account password:(NSString *)password sig:(NSString *)sig {
    _account = account;
    _password = password;
    _sig = sig;
    
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:kRZUserAccount];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kRZUserPassword];
    [[NSUserDefaults standardUserDefaults] setObject:sig forKey:kRZUserSig];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLogin {
    return (BOOL)[AVUser currentUser];
}

- (void)logout {
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotification object:nil];
    [AVUser logOut];
    
    _account = nil;
    _password = nil;
    _sig = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRZUserAccount];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRZUserPassword];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRZUserSig];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
