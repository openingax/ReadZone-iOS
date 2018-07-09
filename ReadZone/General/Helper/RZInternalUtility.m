//
//  RZInternalUtility.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/9.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZInternalUtility.h"

NSString * RZLocalizedString(NSString *key, NSString *comment)
{
    return [[[RZInternalUtility class] bundleForStrings] localizedStringForKey:key value:key table:@"RZInternal"];
}

@implementation RZInternalUtility

+ (NSBundle *)bundleForStrings
{
    static NSBundle *bundle;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundleForClass = [NSBundle bundleForClass:[self class]];
        NSString *stringsBundlePath = [bundleForClass pathForResource:@"RZInternalStrings" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:stringsBundlePath] ?: bundleForClass;
    });
    
    return bundle;
}

@end
