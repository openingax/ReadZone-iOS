//
//  RZAPIBase.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/8/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAPIBase.h"
#import <YYModel/YYModel.h>
#import <AVOSCloud/AVOSCloud.h>

@implementation RZAPIBase

+ (instancetype)fetchDataWithClass:(Class)cls
                     isCurrentUser:(BOOL)isCurrentUser
                          complete:(void (^)(NSArray *data, NSError *error))complete
{
    AVQuery *query = [AVQuery queryWithClassName:[NSString parsePreClassName:NSStringFromClass(cls)]];
    if (isCurrentUser) {
        [query whereKey:@"user" equalTo:[AVUser currentUser]];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray <AVObject *>* _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count == 0) {
                complete(nil, [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"info": @"查询数据为空"}]);
            } else {
                NSMutableArray *datas = [NSMutableArray new];
                for (AVObject *obj in objects) {
                    if ([[obj objectForKey:@"className"] isEqualToString:[NSString parsePreClassName:NSStringFromClass(cls)]]) {
                        NSMutableDictionary *serilizedJSONDictionary = [obj dictionaryForObject];
                        id data = [[cls class] yy_modelWithJSON:serilizedJSONDictionary];
                        [datas addObject:data];
                    }
                }
                complete(datas, nil);
            }
        } else {
            complete(nil, error);
        }
    }];
    
    return nil;
}

@end
