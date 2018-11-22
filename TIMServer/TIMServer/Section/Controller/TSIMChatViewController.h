//
//  TSIMChatViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatViewController.h"
#import "TSIMAdapter.h"

@interface TSIMChatViewController : TSChatViewController <TSChatInputAbleViewDelegate>
{
@protected
    TSChatInputPanel *_inputView;
}

@end
