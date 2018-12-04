//
//  TSChatViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMServerViewController.h"
#import "TSSafeMutableArray.h"
#import "TSIMMsg.h"
#import "TSIMUser.h"
#import "TSChatInputPanel.h"
#import "TSIMMsg+Draft.h"
#import "TSIMMsg+UITableViewCell.h"
#import "TSIMAPlatform.h"

// Video
//#import "TCVideoRecordViewController.h"
//#import "TCNavigationController.h"
//#import "MicroVideoView.h"

@class TSConversation;

@interface TSChatViewController : TSIMServerViewController
{
    
@protected
    
    TSConversation                  *_conversation;
    TSIMUser                        *_receiver;
    
    FBKVOController                 *_receiverKVO;
    
    __weak TSSafeMutableArray       *_messageList;
    
@protected
}

@property(nonatomic,strong) TSConversation *conversation;
@property(nonatomic,strong) TSIMUser *receiver;
@property(nonatomic,readonly) TSSafeMutableArray *messageList;

- (instancetype)initWithUser:(TSIMUser *)user;

- (void)configWithUser:(TSIMUser *)user;


// 加载历史信息
- (void)loadHistotyMessages;

// 添加收到的信息
- (void)appendReceiveMessage;

- (void)sendMsg:(TSIMMsg *)msg;

- (void)updateOnSendMessage:(NSArray *)msglist succ:(BOOL)succ;

- (void)moreViewPhotoAction;
- (void)moreVideVideoAction;

@end
