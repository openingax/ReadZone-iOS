//
//  RZUserManager.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/26.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RZUserManager : NSObject

@property(nonatomic,readonly, copy) NSString *account;
@property(nonatomic,readonly, copy) NSString *password;

+ (RZUserManager *)shareInstance;

- (void)saveUserAccout:(NSString *)account password:(NSString *)password;

- (BOOL)isLogin;

@end

NS_ASSUME_NONNULL_END
