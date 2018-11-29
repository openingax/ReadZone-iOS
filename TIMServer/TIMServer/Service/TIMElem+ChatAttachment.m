//
//  TIMElem+ChatAttachment.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ChatAttachment.h"

@implementation TIMElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(TSIMMsg *)msg
{
    return nil;
}
- (NSArray *)inputAttachmentOf:(TSIMMsg *)msg
{
    return nil;
}
- (NSArray *)chatAttachmentOf:(TSIMMsg *)msg
{
    return nil;
}

@end

@implementation TIMUGCElem (ChatAttachment)

- (NSArray *)singleAttachmentOf:(TSIMMsg *)msg
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"[视频]" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    return @[str];
}
@end
