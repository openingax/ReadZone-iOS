//
//  RZUserInfoModel.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/31.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZUserInfoModel.h"

@implementation RZUserInfoModel

@dynamic user, userName, account, userAvatar, gender, userPoint, phoneModel, screenScale;
+ (NSString *)parseClassName {
    return [NSString parsePreClassName:NSStringFromClass([self class])];
}

@end
