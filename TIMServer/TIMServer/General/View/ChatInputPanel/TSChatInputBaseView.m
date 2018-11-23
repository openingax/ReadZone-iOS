//
//  TSChatInputBaseView.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatInputBaseView.h"

@implementation TSChatInputBaseView

- (instancetype)init
{
    if (self = [super init]) {
        _contentHeight = kIsiPhoneX ? 90 : 56;
    }
    return self;
}

@end
