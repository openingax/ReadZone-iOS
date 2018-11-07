//
//  TIMElem+ShowDescription.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ShowDescription.h"

@implementation TIMElem (ShowDescription)

- (NSString *)showDescriptionOf:(TSIMMsg *)msg {
    return [self description];
}

- (BOOL)isSystemFace {
    return NO;
}

@end


@implementation TIMTextElem (ShowDescription)

- (NSString *)showDescriptionOf:(TSIMMsg *)msg {
    return [self text];
}

@end
