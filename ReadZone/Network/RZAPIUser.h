//
//  RZAPIUser.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/31.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZUserModel.h"

@interface RZAPIUser : NSObject

- (void)fetchUserInfoWithBlock:(void(^)(RZUserModel *userInfo, NSError *error))block;
- (void)fetchDailyWithBlock:(void(^)(id data, NSError *error))block;

@end
