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
    
    _conversation = []
    
    TSConversationManager *manager = [[TSConversationManager alloc] init];
    _conversation = [manager chatWith:_receiver];
    _messageList = _conversation.msgList;
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

@end
