//
//  TIMUserProfile+RZ.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "TIMUserProfile+RZ.h"
#import <objc/runtime.h>

static const void *kConversationKey = &kConversationKey;

@implementation TIMUserProfile (RZ)

- (TIMConversation *)conversation {
    return objc_getAssociatedObject(self, kConversationKey);
}

- (void)setConversation:(TIMConversation *)conversation {
    objc_setAssociatedObject(self, kConversationKey, conversation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
