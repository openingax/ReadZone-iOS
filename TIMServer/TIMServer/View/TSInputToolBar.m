//
//  TSInputToolBar.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/30.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSInputToolBar.h"

@implementation TSInputToolBar

- (instancetype)init {
    if (self = [super init]) {
        _contentHeight = kIsiPhoneX ? 70 : 50;
    }
    return self;
}

@end
