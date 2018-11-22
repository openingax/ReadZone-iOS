//
//  TSIMMsg+Draft.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsg+Draft.h"
#import <objc/runtime.h>

static NSString *const KTIMMessageDraft = @"KTIMMessageDraft";

@implementation TSIMMsg (Draft)

- (TIMMessageDraft *)msgDraft
{
    return objc_getAssociatedObject(self, (__bridge const void *)KTIMMessageDraft);
}

- (void)setMsgDraft:(TIMMessageDraft *)msgDraft
{
    objc_setAssociatedObject(self, (__bridge const void *)KTIMMessageDraft, msgDraft, OBJC_ASSOCIATION_RETAIN);
}


- (instancetype)initWithDraft:(TIMMessageDraft *)msgDraft type:(TSIMMsgType)type
{
    if (self = [super init])
    {
        self.msgDraft = msgDraft;
        
        _msg = [msgDraft transformToMessage];
        _type = type;
        _status = TSIMMsgStatusInit;
    }
    return self;
}


+ (instancetype)msgWithDraft:(TIMMessageDraft *)draft
{
    return [[TSIMMsg alloc] initWithDraft:draft type:TSIMMsgTypeText];
}

- (BOOL)isMsgDraft
{
    return YES;
}

@end
