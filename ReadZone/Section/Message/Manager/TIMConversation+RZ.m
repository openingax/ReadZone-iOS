//
//  TIMConversation+RZ.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "TIMConversation+RZ.h"
#import <objc/runtime.h>

static const void *kIdentifierKey = &kIdentifierKey;
static const void *kFaceURLKey = &kFaceURLKey;
static const void *kNickNameKey = &kNickNameKey;

@implementation TIMConversation (RZ)

- (NSString *)identifier {
    return objc_getAssociatedObject(self, kIdentifierKey);
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, kIdentifierKey, identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)faceURL {
    return objc_getAssociatedObject(self, kFaceURLKey);
}

- (void)setFaceURL:(NSString *)faceURL {
    objc_setAssociatedObject(self, kFaceURLKey, faceURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)nickName {
    return objc_getAssociatedObject(self, kNickNameKey);
}

- (void)setNickName:(NSString *)nickName {
    objc_setAssociatedObject(self, kNickNameKey, nickName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
