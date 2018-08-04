//
//  RZAPIUser.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/31.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAPIUser.h"
#import "RZUserInfoModel.h"
#import <YYModel/YYModel.h>

@implementation RZAPIUser

- (void)fetchUserInfoWithBlock:(void(^)(RZUserModel *userInfo, NSError *error))block {

    AVQuery *query = [AVQuery queryWithClassName:[NSString parsePreClassName:NSStringFromClass([RZUserInfoModel class])]];
    [query whereKey:@"user" equalTo:[AVUser currentUser]];      // 判断是否是当前用户
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count == 0) {
                block(nil, error);
                return;
            }
            
            for (int i=0; i < objects.count; ++i) {
                AVObject *object = [objects objectAtIndex:i];
                if ([object[@"className"] isEqualToString:[NSString parsePreClassName:NSStringFromClass([RZUserInfoModel class])]]) {
                    
                    // 把 object 序列化
                    NSMutableDictionary *serializedJSONDictionary = [object dictionaryForObject];
                    
                    RZUserModel *userInfo = [RZUserModel yy_modelWithDictionary:serializedJSONDictionary];
                    
                    [RZUser shared].userInfo = userInfo;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:[RZUser shared].userInfo];
                    block(userInfo, nil);
                    break;
                } else if (i == objects.count-1) {
                    block(nil, error);
                }
            }
        } else {
            block(nil, error);
        }
    }];
}

- (void)fetchDailyWithBlock:(void (^)(id data, NSError *error))block {
    AVQuery *query = [AVQuery queryWithClassName:@"DailyRecommend"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"data: %@\n", objects);
        block([objects objectAtIndex:0], error);
    }];
}

@end
