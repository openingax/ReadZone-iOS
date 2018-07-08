//
//  RZUtils.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#ifndef RZUtils_h
#define RZUtils_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+RZ.h"

static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


#endif /* RZUtils_h */
