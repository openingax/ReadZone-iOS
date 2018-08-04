//
//  RZAPIHomePage.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/8/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAPIHomePage.h"

@implementation RZAPIHomePage

- (void)fetchHomePageData:(void (^)(RZHomePageModel *data, NSError *error))complete {
    [RZAPIBase fetchDataWithClass:[RZHomePageModel class] isCurrentUser:YES complete:^(NSArray <RZHomePageModel *>*datas, NSError *error) {
        if (!error && datas.count > 0) {
            RZHomePageModel *item = [datas objectAtIndex:0];
            complete(item, nil);
        } else {
            complete(nil, error);
        }
    }];
}

@end
