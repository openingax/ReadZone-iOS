//
//  RZGlobal.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Develop 1
#define IsAtHome 0

@interface RZGlobal : NSObject

@property(nonatomic,strong) NSURL *apiBaseUrl;
@property(nonatomic,strong) dispatch_queue_t jsonDeserializeQueue;

+ (instancetype)shared;

@end
