//
//  RZUser.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/31.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZUserModel.h"

@interface RZUser : NSObject

@property(nonatomic,strong) RZUserModel *userInfo;

+ (instancetype)shared;

@end
