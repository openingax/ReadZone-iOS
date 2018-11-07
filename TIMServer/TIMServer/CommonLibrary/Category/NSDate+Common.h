//
//  NSDate+Common.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

- (BOOL)isToday;
- (BOOL)isYesterday;

- (NSString *)shortTimeTextOfDate;

@end
