//
//  TIMElem+ChatAttachment.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import "TSIMMsg.h"

@interface TIMElem (ChatAttachment)

// 对应会话界面，最后一条消息
- (NSArray *)singleAttachmentOf:(TSIMMsg *)msg;

// 对应聊天界面，输入框
- (NSArray *)inputAttachmentOf:(TSIMMsg *)msg;

// 对应聊天界面的聊天内容
- (NSArray *)chatAttachmentOf:(TSIMMsg *)msg;

@end
