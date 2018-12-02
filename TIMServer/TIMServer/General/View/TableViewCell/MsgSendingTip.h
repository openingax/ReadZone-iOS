//
//  MsgSendingTip.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/10.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TSElemBaseTableViewCell.h"

@interface MsgSendingTip : UIView<TSElemSendingAbleView>
{
@protected
    UIActivityIndicatorView *_sendIng;
    UIImageView             *_sendFailed;
}

@end
