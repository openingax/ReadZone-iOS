//
//  RZAPIError.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

//#import "RZAPIError.h"
//
//@implementation RZAPIError
//
//- (instancetype)initWithRawError:(NSError *)error {
//    self = [super init];
//    if (self) {
//        _rawError = error;
//    }
//    return self;
//}
//
//+ (instancetype)deserializeError:(NSError *)error {
//    return [[RZAPIErrorDeserialize alloc] initWithRawError:error];
//}
//
//+ (instancetype)netTransmitError:(NSError *)error {
//    return [[RZAPIErrorNetTransmit alloc] initWithRawError:error];
//}
//
//+ (instancetype)notSupportHttpMethodError:(NSError *)error {
//    return [[RZAPIErrorNotSupportHttpMethod alloc] initWithRawError:error];
//}
//
//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@\n, rawError:%@", [super description], self.rawError];
//}
//
//@end
//
//@implementation RZAPIErrorDeserialize
//
//@end
//
//@implementation RZAPIErrorNetTransmit
//
//@end
//
//@implementation RZAPIErrorNotSupportHttpMethod
//
//@end
