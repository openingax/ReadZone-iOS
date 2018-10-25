//
//  NSDictionary+RZ.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/24.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "NSDictionary+RZ.h"

@implementation NSDictionary (RZ)

- (id)notNullObjectForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if ([obj isKindOfClass:[NSNull class]]) {
        obj = nil;
    }
    return obj;
}

@end
