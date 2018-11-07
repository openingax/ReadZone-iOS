//
//  TSConstMarco.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#ifndef TSConstMarco_h
#define TSConstMarco_h

#define kTimLargeTextFont       [UIFont systemFontOfSize:16]
#define kTimMiddleTextFont      [UIFont systemFontOfSize:14]
#define kTimSmallTextFont       [UIFont systemFontOfSize:12]

#define kScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight           [[UIScreen mainScreen] bounds].size.height

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kNavTotalHeight (kStatusBarHeight + kNavBarHeight)


#endif /* TSConstMarco_h */
