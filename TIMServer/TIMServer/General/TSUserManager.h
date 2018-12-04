//
//  TSUserManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUserManager : NSObject

@property(nonatomic,readonly,copy) NSString *deviceID;

@property(nonatomic,readonly,copy) NSString *account;
@property(nonatomic,readonly,copy) NSString *userSig;
@property(nonatomic,readonly,copy) NSString *receiver;
@property(nonatomic,readonly,copy) NSString *groupID;

+ (instancetype)shareInstance;

- (void)saveDeviceID:(NSString *)deviceID;
- (void)saveAccount:(NSString *)account;
- (void)saveUserSig:(NSString *)userSig;
- (void)saveUserAccount:(NSString *)account userSig:(NSString *)sig receiver:(NSString *)receiver;
- (void)saveGroupID:(NSString *)groupID;

- (BOOL)isLogin;

- (void)deleteUserSig;

@end
