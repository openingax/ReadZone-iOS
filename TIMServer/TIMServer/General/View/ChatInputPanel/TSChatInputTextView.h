//
//  TSChatInputTextView.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatTextView.h"
#import <IMMessageExt/IMMessageExt.h>
#import "TSIMMsg+Draft.h"

@interface TSChatInputTextView : TSChatTextView

- (TSIMMsg *)getMultiMsg;
- (TSIMMsg *)getDraftMsg;
- (void)setDraftMsg:(TSIMMsg *)draft;

@end
