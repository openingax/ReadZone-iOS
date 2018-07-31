//
//  RZUser.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/31.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZUser.h"

@implementation RZUser

+ (instancetype)shared {
    static RZUser *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[RZUser alloc] init];
    });
    return shared;
}

@end
