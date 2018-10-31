//
//  TIMServerHelper.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMServerHelper.h"

NSString * TIMLocalizedString(NSString *key, NSString *comment)
{
    return [[[TIMServerHelper class] bundleForStrings] localizedStringForKey:key value:key table:@"Localizable"];
}

@implementation TIMServerHelper

+ (NSBundle *)timServerBundle {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"TIMServer" ofType:@"bundle"]];
}

+ (NSBundle *)bundleForStrings
{
    static NSBundle *bundle;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundleForClass = [NSBundle bundleForClass:[self class]];
        NSString *stringsBundlePath = [bundleForClass pathForResource:@"TIMServerLocalizable" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:stringsBundlePath] ?: bundleForClass;
    });
    
    return bundle;
}

@end


@implementation UIImage (Bundle)

+ (UIImage *)imageWithBundleAsset:(NSString *)assetName {
    NSBundle *timServerBundle = [TIMServerHelper timServerBundle];
    
    if (timServerBundle && assetName) {
        return [UIImage imageWithContentsOfFile:[[timServerBundle resourcePath] stringByAppendingPathComponent:[@"Images/" stringByAppendingString: assetName]]];
    } else {
        return nil;
    }
}

@end
