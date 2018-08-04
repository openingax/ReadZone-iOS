//
//  RZAPIBase.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/8/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface RZAPIBase : NSObject

+ (instancetype)fetchDataWithClass:(Class)cls
                     isCurrentUser:(BOOL)isCurrentUser
                          complete:(void (^)(NSArray *data, NSError *error))complete;

@end
