//
//  NSDictionary+ym.h
//  YMCommonFrameWork
//
//  Created by liushilou on 16/12/21.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ymc)

//如果为Null,则转为nil
- (id)notNullObjectForKey:(NSString *)key;

//转换为get方式的URL参数
- (NSString*)transFormToUrlString;

//转化为json字符串
- (NSString*)jsonString;

@end
