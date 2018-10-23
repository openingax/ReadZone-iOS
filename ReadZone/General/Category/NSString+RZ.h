//
//  NSString+RZ.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/3.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RZ)

// 检查字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string;

+ (NSString *)parsePreClassName:(NSString *)string;

// 去掉字符串两边的空格
+ (NSString *)stringByCuttingEdgeWhitespace:(NSString *)string;
// 去掉字符串两边的空格与换行符
+ (NSString *)stringByCuttingEdgeWhiteSpaceAndNewlineCharacterSet:(NSString *)string;

@end
