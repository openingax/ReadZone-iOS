//
//  RZAPI.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZAPIResponse.h"
#import "RZAPIError.h"

@class RZAPI;

typedef NS_ENUM(NSUInteger, RZAPIHTTPMethod) {
    RZAPIHTTPMethodGet = 1,
    RZAPIHTTPMethodPost,
    RZAPIHTTPMethodPut,
    RZAPIHTTPMethodDelete
};

#pragma mark - RZAPIConfiguration
@interface RZAPIConfiguration : NSObject

@property(nonatomic,copy) NSString *relativePath;
@property(nonatomic,assign) RZAPIHTTPMethod method;
@property(nonatomic,strong) Class clsOfResData;
@property(nonatomic,assign) BOOL resDataIsArray;

+ (instancetype)configurationWithRelativePath:(NSString *)path
                                       method:(RZAPIHTTPMethod)method
                            respObjectWithCls:(Class)cls
                                  dataIsArray:(BOOL)dataIsArray;

@end

#pragma mark - TIAPI
typedef NSString*(^FetchTokenAction) (void);
@interface RZAPI<ResDataType> : NSObject

@property(nonatomic,strong) RZAPIResponse<ResDataType> *response;
@property(nonatomic,strong) RZAPIError *error;

+ (void)setFetchTokenAction:(FetchTokenAction)action;
// Public
- (void)startWithCompletion:(void(^)(RZAPI<ResDataType> *api))completion;

// For Override
- (NSDictionary<NSString *, NSString *> *)parameters;
- (Class)clsOfRespData;

// Abstract Method
- (RZAPIConfiguration *)apiConfiguration;

@end


