//
//  TSAPIUser.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/3.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSAPIUser.h"
#import "TSConfig.h"
#import "AFNetworking.h"
#import "NSString+Common.h"
#import <YMCommon/NSDictionary+ymc.h>

@interface TSAPIUser ()

@property(nonatomic,strong) AFHTTPSessionManager *manager;

@end

@implementation TSAPIUser

- (instancetype)init {
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = 8.0f;
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)registerWithAccount:(NSString *)account userIcon:(NSString *)userIcon complete:(void (^)(BOOL, NSString *, NSDictionary *))block {
    
    
    NSString *url = [NSString stringWithFormat:@"%@/device/im/user/register", kBaseUrl];
    
    [self.manager POST:url parameters:@{
                                    @"identifier" : account,
                                    @"password" : @"",
                                    @"nickname" : @"",
                                    @"faceUrl" : [NSString isEmpty:userIcon] ? @"" : userIcon
                                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                                        
                                    } success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSDictionary *result = (NSDictionary *)responseObject;
                                        NSDictionary *data = [result notNullObjectForKey:@"mobBaseRes"];
                                        if ([data isKindOfClass:[NSDictionary class]]) {
                                            block (YES, @"", data);
                                        } else {
                                            block(NO, @"返回值解析出错", nil);
                                        }
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        block(NO, @"获取数据失败", nil);
                                    }];
}

- (void)loginWithAccount:(NSString *)account complete:(void (^)(BOOL isSuccess, NSString *message, NSDictionary *data))block {
    NSString *url = [NSString stringWithFormat:@"%@/device/im/user/login", kBaseUrl];
    
    [self.manager POST:url parameters:@{
                                    @"identifier" : account,
                                    @"password" : @""
                                    } progress:^(NSProgress * _Nonnull uploadProgress) {
                                        
                                    } success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSDictionary *result = (NSDictionary *)responseObject;
                                        NSDictionary *data = [result notNullObjectForKey:@"mobBaseRes"];
                                        if ([data isKindOfClass:[NSDictionary class]]) {
                                            block (YES, @"", data);
                                        } else {
                                            block(NO, @"返回值解析出错", nil);
                                        }
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        block(NO, @"获取数据失败", nil);
                                    }];
}

@end
