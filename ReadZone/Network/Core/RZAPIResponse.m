//
//  RZAPIResponse.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

//#import "RZAPIResponse.h"
//#import <MJExtension/MJExtension.h>
//
//@interface RZAPIResponse ()
//
//@property(nonatomic,strong) id data;
//
//@end
//
//@implementation RZAPIResponse
//
//- (id)fetchData {
//    return self.data;
//}
//
//- (NSError *)parseFromJSONDic:(NSDictionary *)jsonDic clsOfData:(Class)cls dataIsArray:(BOOL)dataIsArray {
//    if (![jsonDic isKindOfClass:[NSDictionary class]]) {
//        return [NSError errorWithDomain:@"JSON is Not A Dic" code:0 userInfo:nil];
//    }
//    
//    RZAPIResponse *response = [RZAPIResponse mj_objectWithKeyValues:jsonDic];
//    if ([RZAPIResponse mj_error]) {
//        return [RZAPIResponse mj_error];
//    }
//    
//    self.code = response.code;
//    self.message = response.message;
//    
//    if (cls) {
//        id dataJson = jsonDic[@"result"];
//        if (dataIsArray && [dataJson isKindOfClass:[NSArray class]]) {
//            self.data = [cls mj_objectArrayWithKeyValuesArray:dataJson];
//        } else {
//            self.data = [cls mj_objectWithKeyValues:dataJson];
//        }
//        
//        if ([RZAPIResponse mj_error]) {
//            return [RZAPIResponse mj_error];
//        }
//    }
//    
//    return nil;
//}
//
//#pragma mark - MJExtension
//+ (NSArray *)mj_ignoredCodingPropertyNames {
//    return @[ @"result" ];
//}
//
//@end
