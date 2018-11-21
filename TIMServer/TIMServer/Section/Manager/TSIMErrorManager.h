//
//  TSIMErrorManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/19.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSIMErrorManager : NSObject

+ (NSString *)getErrorWithCode:(NSInteger)code;

@end
