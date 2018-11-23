//
//  TIMElem+ShowAPIs.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ShowAPIs.h"
#import "TSChatBaseTableViewCell.h"

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
