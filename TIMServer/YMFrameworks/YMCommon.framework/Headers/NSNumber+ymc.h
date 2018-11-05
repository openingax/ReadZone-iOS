//
//  NSNumber+ym.h
//  yunSale
//
//  Created by 谢立颖 on 2016/12/14.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (ymc)

//#warning 有问题
//把 NSNumber 类型的数值转为带两位小数的 NSString 形式，保证数值精度不丢失（floatValue 会造成精度丢失）
+ (NSString *)formatNumberStringWithNumber:(NSNumber *)number;

@end
