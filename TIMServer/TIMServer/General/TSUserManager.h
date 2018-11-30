//
//  TSUserManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSUserManager : NSObject

@property(nonatomic,readonly,copy) NSString *account;
@property(nonatomic,readonly,copy) NSString *userSig;
@property(nonatomic,readonly,copy) NSString *receiver;

+ (instancetype)shareInstance;

- (void)saveUserAccount:(NSString *)account userSig:(NSString *)sig receiver:(NSString *)receiver;
- (BOOL)isLogin;

@end
