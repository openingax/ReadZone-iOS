//
//  TSAPIUser.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/3.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAPIUser : NSObject

- (void)registerWithAccount:(NSString *)account
                   userIcon:(NSString *)userIcon
                   complete:(void (^)(BOOL isSucc, NSString *message, NSDictionary *dict))block;
- (void)loginWithAccount:(NSString *)account complete:(void (^)(BOOL isSuccess, NSString *message, NSDictionary *data))block;

@end
