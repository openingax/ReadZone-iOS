//
//  RZMsgChatViewController.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZBaseViewController.h"
#import "TIMUserProfile+RZ.h"

NS_ASSUME_NONNULL_BEGIN

@class TIMConversation;

@interface RZMsgChatViewController : RZBaseViewController

@property(nonatomic,strong) TIMConversation *conversaion;

@end

NS_ASSUME_NONNULL_END
