//
//  TSIMAPlatformHeaders.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/3.
//  Copyright © 2018 Viomi. All rights reserved.
//

#ifndef TSIMAPlatformHeaders_h
#define TSIMAPlatformHeaders_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMARefreshStyle) {
    EIMARefresh_None,   // 无更新
    EIMARefresh_ING,    // 正在刷新
    EIMARefresh_Wait,   // 正在刷新，下一个须等待
};


#endif /* TSIMAPlatformHeaders_h */
