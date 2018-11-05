//
//  NSString+ym.h
//  yunSale
//
//  Created by liushilou on 16/11/30.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ymc)

//去掉左右两端空格和换行符
- (NSString *)noWhitespaceAndNewlineCharacterString;

//去掉左右两端空格
- (NSString *)noWhitespaceCharacterString;

+ (BOOL)isValidPhone:(NSString *)phoneNum;

/**
 检验密码是否合法（合法的规则是：是否包含数字以及大小写字母，长度为6~18位）
 
 @param password 待检验的密码
 @return 返回值
 */
+ (BOOL)isLegalPassword:(NSString *)password;

- (CGFloat)widthWithFontsize:(CGFloat)size;

- (CGFloat)heightWithWidth:(CGFloat)width fontsize:(CGFloat)size;

//判断字符串是否为空字符串，（nil、""、"(null)"、"<null>"）都判断为空
+ (BOOL)isEmptyString:(NSString *)string;

- (BOOL)isEmpty;

- (NSString*)encodeUrl;

- (NSString*)decodeUrl;

- (NSString *)md5;

- (BOOL)isContainSpace;
//判断特殊字符
- (BOOL)isIncludeSpecialCharact;
//判断表情字符
- (BOOL)isContrainsEmoji;
@end
