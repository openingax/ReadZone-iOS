//
//  NSObject+CommonBlock.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CommonVoidBlock)();

typedef void (^CommonBlock)(id selfPtr);

typedef void (^CommonCompletionBlock)(id selfPtr, BOOL isFinished);

@interface NSObject (CommonBlock)

@end

