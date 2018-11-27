//
//  TSChatViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatViewController.h"
#import "TSInputToolBar.h"
#import "TSConstMarco.h"
#import "TSIMMsgCell.h"
#import "UIView+CustomAutoLayout.h"
#import "UIView+Toast.h"
#import "TSConversation.h"
#import "TSConversationManager.h"
#import "TIMServerHelper.h"
#import "TSColorMarco.h"
#import <Masonry/Masonry.h>
#import "TSIMAPlatform.h"

@interface TSChatViewController ()

@end

@implementation TSChatViewController

- (instancetype)initWithUser:(TSIMUser *)user {
    if (self = [super init]) {
        _receiver = user;
    }
    return self;
}

- (void)configWithUser:(TSIMUser *)user {
    
    [_receiverKVO unobserveAll];
    
    _receiver = user;
    
    [self setChatTitle];
//    __weak TSChatViewController *ws = self;
//
//    _receiverKVO = [FBKVOController controllerWithObserver:self];
//
//    [_receiverKVO observe:_receiver keyPaths:@[@"remark", @"nickName"] options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//        [ws setChatTitle];
//    }];
    
    if (_conversation) {
        [_conversation releaseConversation];
        _messageList = nil;
        [self reloadData];
    }
}

- (void)didLogin {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_conversation = [[TSIMAPlatform sharedInstance].conversationMgr chatWith:self->_receiver];
        self->_messageList = self->_conversation.msgList;
        
        __weak TSChatViewController *ws = self;
//        [self->_conversation asyncLoadRecentMessage:10 completion:^(NSArray *imMsgList, BOOL succ) {
//            [ws onLoadRecentMessage:imMsgList complete:succ scrollToBottom:YES];
//        }];
        
        self->_conversation.receiveMsg = ^(NSArray *imMsgList, BOOL succ) {
            [ws onReceiveNewMsg:imMsgList succ:succ];
            [ws updateMessageList];
        };
        
        [[TSIMAPlatform sharedInstance].conversationMgr asyncConversationList];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configWithUser:_receiver];
    
    self.view.backgroundColor = kWhiteColor;
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.tableView addGestureRecognizer:tapAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_receiverKVO unobserveAll];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiddenKeyBoard {
    
}

- (void)setChatTitle {
    self.title = TIMLocalizedString(@"MSG_NAV_TITLE", @"留言板");
}


#pragma mark - Add View
- (void)addHeaderView {
    // 添加头部视图
    
}

- (void)addOwnViews {
    [super addOwnViews];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.f;
    
    [self addChatToolBar];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGr.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPressGr];
}

- (void)addChatToolBar {
    
}

- (void)layoutRefreshScrollView {
  
    CGFloat kToolbarY = CGRectGetMaxY(self.view.bounds) - CHAT_BAR_MIN_H - 2*CHAT_BAR_VECTICAL_PADDING;
    // do nothing
    _tableView.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), kToolbarY);
}

-(void)onLongPress:(UILongPressGestureRecognizer *)gesture
{
    
//    if(gesture.state == UIGestureRecognizerStateBegan)
//    {
//        CGPoint point = [gesture locationInView:self.tableView];
//
//        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
//        UITableViewCell<TIMElemAbleCell> *cell = [_tableView cellForRowAtIndexPath:indexPath];
//        BOOL showMenu = [cell canShowMenu];
//
//        if (showMenu)
//        {
//            if ([cell canShowMenuOnTouchOf:gesture])
//            {
//                [cell showMenu];
//            }
//        }
//    }
}

- (void)sendMsg:(TSIMMsg *)msg
{
    if (msg)
    {
        //        _isSendMsg = YES;
        [_tableView beginUpdates];
        
        __weak TSChatViewController *ws = self;
        DebugLog(@"will sendmessage");
        
        NSArray *newaddMsgs = [_conversation sendMessage:msg completion:^(NSArray *imamsglist, BOOL succ, int code) {
            
            DebugLog(@"sendmessage end");
            [ws updateOnSendMessage:imamsglist succ:succ];
            
            if (!succ)
            {
                if (code == 80001)
                {
                    TSIMMsg *msg = [TSIMMsg msgWithCustom:TSIMMsgTypeSaftyTip];
                    [self->_messageList addObject:msg];
                    
                    [self showMsgs:@[msg]];
                }
            }
        }];
        
        [self showMsgs:newaddMsgs];
    }
}

- (void)onReceiveNewMsg:(NSArray *)imamsgList succ:(BOOL)succ
{
    [_tableView beginUpdates];
    
    NSInteger count = [imamsgList count];
    NSMutableArray *indexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger idx = _messageList.count + i - count;
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexArray addObject:index];
    }
    
    [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    [_tableView endUpdates];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateOnSendMessage:imamsgList succ:YES];
    });
}

//当消息量过大时，需要清理部分消息，避免内存持续增长
- (void)updateMessageList
{
    if (_messageList.count > 1000)
    {
        DebugLog(@"_messageList.count > 1000");
        int rangLength = 100;
        NSRange range = NSMakeRange(_messageList.count-rangLength, rangLength);
        [_messageList subArrayWithRange:range];
        [_tableView reloadData];
    }
}

- (void)showMsgs:(NSArray *)msgs
{
    NSMutableArray *array = [NSMutableArray array];
    for (TSIMMsg *msg in msgs)
    {
        NSInteger idx = [_messageList indexOfObject:msg];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [array addObject:index];
    }
    
    [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
    [_tableView endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath *index = [NSIndexPath indexPathForRow:self->_messageList.count - 1 inSection:0];
        [self->_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    });
}

- (void)sendText:(NSString *)text
{
    if (text && text.length > 0)
    {
        TSIMMsg *msg = [TSIMMsg msgWithText:text];
        [self sendMsg:msg];
    }
}

- (void)didChangeToolBarHight:(CGFloat)toHeight
{
    __weak TSChatViewController* weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = weakself.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = weakself.view.frame.size.height - toHeight;
        weakself.tableView.frame = rect;
    }];
    
    if (_tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSIMMsg *msg = [_messageList objectAtIndex:indexPath.row];
    return [msg heightInWidth:tableView.bounds.size.width inStyle:_conversation.type == TIM_GROUP];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSIMMsg *msg = [_messageList objectAtIndex:indexPath.row];
    
    UITableViewCell<TSElemAbleCell> *cell = [msg tableView:tableView style:[_receiver isC2CType] ? TSElemCellStyleC2C : TSElemCellStyleGroup];
    [cell configWith:msg];
    return cell;
}

#pragma mark - Load Message
- (void)onLoadRecentMessage:(NSArray *)imamsgList complete:(BOOL)succ scrollToBottom:(BOOL)scroll
{
    if (succ)
    {
        if (imamsgList.count > 0)
        {
            [_tableView beginUpdates];
            
            NSMutableArray *ar = [NSMutableArray array];
            for (NSInteger i = 0; i < imamsgList.count; i++)
            {
                [ar addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
            [_tableView insertRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationTop];
            
            [_tableView endUpdates];
            
            if (scroll)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    NSIndexPath *last = [NSIndexPath indexPathForRow:imamsgList.count-1 inSection:0];
                    [self.tableView scrollToRowAtIndexPath:last atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                });
            }
        }
    }
}

- (void)updateOnSendMessage:(NSArray *)msglist succ:(BOOL)succ
{
    if (msglist.count)
    {
        
        NSInteger index = [_messageList indexOfObject:msglist.lastObject];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
