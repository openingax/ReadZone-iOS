//
//  RZWebKitManager.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/24.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RZWebKitManager : NSObject

+ (NSDictionary *)dictionaryWithJSONFile:(NSString *)path;
+ (void)dictionaryWithJSONFile:(NSString *)path complete:(void (^)(NSError *error, NSDictionary* result))complete;

@end

NS_ASSUME_NONNULL_END
