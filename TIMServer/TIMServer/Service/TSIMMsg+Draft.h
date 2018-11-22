//
//  TSIMMsg+Draft.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsg.h"
#import <IMMessageExt/IMMessageExt.h>

@interface TSIMMsg (Draft)

@property (nonatomic, strong) TIMMessageDraft *msgDraft;

+ (instancetype)msgWithDraft:(TIMMessageDraft *)draft;

- (BOOL)isMsgDraft;

@end
