//
//  TIAPI.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

//#import "RZAPI.h"
//#import "RZGlobal.h"
//#import <AFNetworking/AFNetworking.h>
//
//@implementation RZAPIConfiguration
//
//+ (instancetype)configurationWithRelativePath:(NSString *)path method:(RZAPIHTTPMethod)method respObjectWithCls:(Class)cls dataIsArray:(BOOL)dataIsArray {
//    RZAPIConfiguration *configuration = [[RZAPIConfiguration alloc] init];
//    configuration.relativePath = path;
//    configuration.method = method;
//    configuration.clsOfResData = cls;
//    configuration.resDataIsArray = dataIsArray;
//    return configuration;
//}
//
//@end
//
//@interface RZAPI ()
//
//@property(nonatomic,strong) AFHTTPSessionManager *httpManager;
//
//@end
//
//static FetchTokenAction fetchTokenAction;
//@implementation RZAPI
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[RZGlobal shared].apiBaseUrl];
//        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    }
//    return self;
//}
//
//+ (void)setFetchTokenAction:(FetchTokenAction)action {
//    fetchTokenAction = action;
//}
//
//- (void)startWithCompletion:(void (^)(RZAPI<id> *api))completion {
//    RZAPIConfiguration *configuration = [self apiConfiguration];
//    
//    @weakify(self);
//    void(^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
//        @strongify(self);
//        
//        NSLog(@"responseObject: %@", responseObject);
//        
//        RZAPIResponse *resp = [[RZAPIResponse alloc] init];
//        NSError *parseError = [resp parseFromJSONDic:responseObject clsOfData:configuration.clsOfResData dataIsArray:configuration.resDataIsArray];
//        
//        self.response = resp;
//        if (parseError) {
//            self.error = [RZAPIError deserializeError:parseError];
//        }
//        
//        if (completion) { completion(self); }
//    };
//    
//    void (^failureBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
//        @strongify(self);
//        
//        NSLog(@"responseObject: %@", error);
//        
//        if (completion) { completion(self); }
//    };
//    
//    NSString *token = fetchTokenAction();
//    if (token.length > 0) {
//        [self.httpManager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
//    }
//    
//    switch (configuration.method) {
//        case RZAPIHTTPMethodGet: {
//            [self.httpManager GET:configuration.relativePath parameters:[self parameters] progress:nil success:successBlock failure:failureBlock];
//        }
//            break;
//        case RZAPIHTTPMethodPut: {
//            [self.httpManager PUT:configuration.relativePath parameters:[self parameters] success:successBlock failure:failureBlock];
//        }
//            break;
//        case RZAPIHTTPMethodPost: {
//            [self.httpManager POST:configuration.relativePath parameters:[self parameters] progress:nil success:successBlock failure:failureBlock];
//        }
//            break;
//        case RZAPIHTTPMethodDelete: {
//            [self.httpManager DELETE:configuration.relativePath parameters:[self parameters] success:successBlock failure:failureBlock];
//        }
//            break;
//        default: {
//            self.error = [RZAPIError notSupportHttpMethodError:nil];
//            if (completion) { completion(self); }
//        }
//            break;
//    }
//}
//
//- (NSDictionary<NSString *, NSString *> *)parameters { return nil; }
//- (RZAPIConfiguration *)apiConfiguration { return nil; }
//- (Class)clsOfRespData { return nil; }

@end
