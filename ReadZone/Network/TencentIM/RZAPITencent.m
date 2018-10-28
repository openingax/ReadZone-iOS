//
//  RZAPITencent.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/27.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZAPITencent.h"
#import <AFNetworking/AFNetworking.h>

@implementation RZAPITencent

- (void)fetchSigWithAccount:(NSString *)account complete:(void (^)(BOOL, NSString *))block {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: kBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/sig" parameters:@{@"account" : account} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *sig = (NSDictionary *)responseObject;
        block(YES, [sig notNullObjectForKey:@"sig"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(NO, @"失败");
    }];
}

@end
