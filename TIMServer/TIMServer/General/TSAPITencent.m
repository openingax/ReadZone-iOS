//
//  TSAPITencent.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSAPITencent.h"
#import "NSString+Common.h"

static NSString * const baseUrl = @"http://www.xieliying.com:3000";

@implementation TSAPITencent

- (void)fetchSigWith:(NSString *)account complete:(void (^)(BOOL, NSString * _Nonnull))block {
    if ([NSString isEmpty:account]) {
        block(NO, @"");
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/sig?account=%@", baseUrl, account]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data && !error) {
            block(YES, [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil] objectForKey:@"sig"]);
        }
    }];
    
    [dataTask resume];
}

@end
