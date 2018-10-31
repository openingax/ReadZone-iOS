//
//  TSDebugMarco.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#ifndef TSDebugMarco_h
#define TSDebugMarco_h

#ifdef DEBUG
#define DebugLog(fmt, ...) NSLog((@"[%s Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#ifndef DebugLog
#define DebugLog(fmt, ...) // NSLog((@"[%s Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif


#endif /* TSDebugMarco_h */
