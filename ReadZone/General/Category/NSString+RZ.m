//
//  NSString+RZ.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/3.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "NSString+RZ.h"

@implementation NSString (RZ)

+ (BOOL)checkIsEmptyOrNull:(NSString *)string {
    if (string && ![string isEqual:[NSNull null]] && ![string isEqual:@"(null)"] && ![string isEqualToString:@"<null>"] && [string length] > 0) {
        return NO;
    }
    return YES;
}

+ (NSString *)parsePreClassName:(NSString *)string {
    if ([string hasPrefix:@"RZ"]) {
        return [string substringWithRange:NSMakeRange(2, string.length-2)];
    }
    return string;
}

@end
