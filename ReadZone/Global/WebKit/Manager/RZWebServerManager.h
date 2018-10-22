//
//  RZWebServerManager.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/22.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RZWebServerManager : NSObject

+ (RZWebServerManager *)shareInstance;

- (BOOL)start;
- (void)stop;
- (NSUInteger)port;
- (BOOL)isRunning;

@end

NS_ASSUME_NONNULL_END
