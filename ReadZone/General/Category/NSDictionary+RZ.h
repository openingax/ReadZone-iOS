//
//  NSDictionary+RZ.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/24.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (RZ)

- (id)notNullObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
