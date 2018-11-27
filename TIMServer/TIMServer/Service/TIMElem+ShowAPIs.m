//
//  TIMElem+ShowAPIs.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ShowAPIs.h"
#import "TSChatTableViewCell.h"
#import "TSChatTimeTipTableViewCell.h"

@implementation TIMElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg
{
    return [TSChatBaseTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg
{
    return CGSizeMake(width, 32);
}

@end

@implementation TIMTextElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg
{
    return [TSChatTextTableViewCell class];
}

- (CGSize)sizeInWidth:(CGFloat)width atMsg:(TSIMMsg *)packMsg
{
    CGSize size = [self.text textSizeIn:CGSizeMake(width, HUGE_VAL) font:[packMsg textFont]];
    
    if (size.height < kIMAMsgMinHeigth) {
        size.height = kIMAMsgMinHeigth;
    }
    return size;
}

@end

@implementation TIMCustomElem (ShowAPIs)

- (Class)showCellClassOf:(TSIMMsg *)msg {
    if (msg.type == TSIMMsgTypeTimeTip) {
        return [TSChatTimeTipTableViewCell class];
    } else if (msg.type == TSIMMsgTypeSaftyTip) {
        return [TSChatSaftyTipTableViewCell class];
    } else if (msg.type == TSIMMsgTypeRevokedTip) {
        return [TSRevokedTipTableViewCell class];
    } else {
        return [super showCellClassOf:msg];
    }
}

@end
