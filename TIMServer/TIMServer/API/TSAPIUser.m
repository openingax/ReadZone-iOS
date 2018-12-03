//
//  TSAPIUser.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/3.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSAPIUser.h"
#import "TSConfig.h"
#import "NSString+Common.h"

@implementation TSAPIUser

- (void)registerWithAccount:(NSString *)account
                   userIcon:(NSString *)userIcon
                   complete:(void (^)(BOOL isSuccess, NSString *message, NSDictionary *data))block {
    NSString *url = @"/device/im/user/register";
    [self asynPostToUrl:url widthData:@{
                                        @"account": [NSString isEmpty:account] ? @"" : account,
                                        @"faceUrl": [NSString isEmpty:userIcon] ? @"" : userIcon
                                        } type:YMCRequestTypeYunmi completeBlock:^(YMCRequestStatus status, NSString *message, NSDictionary *data) {
        if (status == YMCRequestSuccess) {
            block(YES, @"", data);
        } else {
            block(NO, message, nil);
        }
    }];
}

- (void)loginWithAccount:(NSString *)account complete:(void (^)(BOOL isSuccess, NSString *message, NSDictionary *data))block {
    NSString *url = @"/device/im/user/login";
    [self asynPostToUrl:url widthData:@{@"account" : [NSString isEmpty:account] ? @"" : account} type:YMCRequestTypeYunmi completeBlock:^(YMCRequestStatus status, NSString *message, NSDictionary *data) {
        if (status == YMCRequestSuccess) {
            block(YES, @"", data);
        } else {
            block(NO, message, nil);
        }
    }];
}

@end
