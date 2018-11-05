//
//  YMAppUpdateAPI.h
//  yunSale
//
//  Created by liushilou on 16/11/30.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import "YMCBaseAPIManager.h"

@interface YMCAppUpdateAPI : YMCBaseAPIManager

//更新提示频率，默认为1天；
@property(nonatomic,assign) NSInteger daysOfAlertFrequency;

- (void)checkVersion:(NSString *)appId;

+ (NSString *)appUpdateUrl;

+ (NSString *)latestAppversion;
    
+ (BOOL)isNeedToUpdate;

@end
