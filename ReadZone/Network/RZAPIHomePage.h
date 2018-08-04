//
//  RZAPIHomePage.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/8/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAPIBase.h"
#import "RZHomePageModel.h"

@interface RZAPIHomePage : RZAPIBase

- (void)fetchHomePageData:(void(^)(RZHomePageModel *data, NSError *error))complete;

@end
