//
//  TIMServerHelper.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Returns a localized version of the string designated by the specified key and residing in the RZInternal.
 
 @param key The key for a string in the RZInternal.
 @param comment The comment to place above the key-value pair in the strings file.
 
 @return A localized version of the string designated by key in the RZInternal.
 */
FOUNDATION_EXPORT NSString * TIMLocalizedString(NSString *key, NSString *comment);

@interface TIMServerHelper : NSObject

/**
 Return the NSBundle object for returning localized strings
 
 @return The NSBundle object for returning localized strings.
 */
+ (NSBundle *)bundleForStrings;

@end


@interface UIImage (Bundle)

+ (UIImage *)imageWithBundleAsset:(NSString *)assetName;

@end
