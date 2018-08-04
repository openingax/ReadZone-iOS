//
//  RZHomePageModel.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/8/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZHomePageModel.h"
#import <YYModel/YYModel.h>

@implementation Book

@end

@implementation RZHomePageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"books":[Book class]};
}

@end
