//
//  TSAPITencent.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSAPITencent : NSObject

- (void)fetchSigWith:(NSString *)account complete:(void(^)(BOOL isSuccess, NSString *sig))block;

@end

NS_ASSUME_NONNULL_END
