//
//  RZGlobal.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZGlobal.h"

@implementation RZGlobal

+ (instancetype)shared {
    static RZGlobal *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[RZGlobal alloc] init];
    });
    return shared;
}

- (NSURL *)apiBaseUrl {
#if IsAtHome
    return [NSURL URLWithString:@"http://192.168.0.100:8000/"];
#else
    return [NSURL URLWithString:@"http://192.168.31.227:8000/"];
#endif
}

@end
