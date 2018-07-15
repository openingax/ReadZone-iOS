//
//  RZHotPotModel.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/12.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZHotPotModel.h"

@implementation RZHotPotModel

// 必须加上这条 @dynamic 动态生成 setter、getter 方法的语句，且在初始化对象时，要先注册对象（registerSubclass）
@dynamic user, hotPotImg, headlineStr, sourceStr;

+ (NSString *)parseClassName {
    return @"hotPotModel";
}

@end
