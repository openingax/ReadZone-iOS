//
//  RZConfig.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/23.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#ifndef RZConfig_h
#define RZConfig_h

//app 测试环境和正式环境切换: 0 正式环境 1测试环境
#ifdef DEBUG
#define Develop 1
#else
#define Develop 0
#endif

#define kBaseURL @"http://www.xieliying.com:3000"

#endif /* RZConfig_h */
