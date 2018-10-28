//
//  RZAPITencent.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/27.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZAPITencent : NSObject

- (void)fetchSigWithAccount:(NSString *)account complete:(void(^)(BOOL isSuccess, NSString *sig))block;

@end
