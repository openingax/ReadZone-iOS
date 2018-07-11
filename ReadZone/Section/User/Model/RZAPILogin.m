//
//  RZAPILogin.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAPILogin.h"
#import "RZDTOLogin.h"

@implementation RZAPILogin

- (RZAPIConfiguration *)apiConfiguration {
    return [RZAPIConfiguration configurationWithRelativePath:@"users/login" method:RZAPIHTTPMethodPost respObjectWithCls:[RZDTOLogin class] dataIsArray:NO];
}

- (NSDictionary<NSString *, NSString *> *)parameters {
    return @{
             @"account": self.account ? : @"",
             @"password": self.password ? : @""
             };
}

@end
