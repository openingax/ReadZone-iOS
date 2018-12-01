//
//  TSIMChatViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMChatViewController.h"

@interface TSIMChatViewController ()

@end

@implementation TSIMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册消息相关的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRevokeMsg:) name:kIMAMSG_RevokeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteMsg:) name:kIMAMSG_DeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResendMsg:) name:kIMAMSG_ResendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangedMsg:) name:kIMAMSG_ChangedNotification object:nil];
}

- (void)dealloc {
    
    [self.KVOController unobserveAll];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)onRevokeMsg:(NSNotification *)noti {
    
}

- (void)onDeleteMsg:(NSNotification *)noti {
    
}

- (void)onResendMsg:(NSNotification *)noti {
    
}

- (void)onChangedMsg:(NSNotification *)noti {
    TSIMMsg *msg = (TSIMMsg *)noti.object;
    
    NSInteger idx = [_conversation.msgList indexOfObject:msg];
    if (idx >= 0 && idx < _conversation.msgList.count)
    {
        [_tableView beginUpdates];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
    }
}

#pragma mark - View

- (void)addInputPanel {
    _inputView = [[TSChatInputPanel alloc] init];
    _inputView.chatDelegate = self;
    [self.view addSubview:_inputView];
}

- (void)addChatToolBar {
    
    [self addInputPanel];
    
    self.KVOController = [FBKVOController controllerWithObserver:self];
    __weak TSIMChatViewController *ws = self;
    [self.KVOController observe:_inputView keyPath:@"contentHeight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        [ws onInputViewContentHeightChanged:change];
    }];
}

- (void)onInputViewContentHeightChanged:(NSDictionary *)change
{
    NSInteger nv = [change[NSKeyValueChangeNewKey] integerValue];
    NSInteger ov = [change[NSKeyValueChangeOldKey] integerValue];
    if (nv != ov)
    {
        // nv > ov 说明是展开，否则是缩回
        // TODO：界面消息较少时，下面的做法将顶部消息顶出去，可根据内容显示再作显示优化
        NSInteger off = nv - ov;
        if (_tableView.contentSize.height + off <= _tableView.bounds.size.height)
        {
            CGRect rect = _tableView.frame;
            rect.size.height -= off;
            _tableView.frame = rect;
        }
        else
        {
            CGRect rect = _tableView.frame;
            if (rect.origin.y == 0)
            {
                rect.size.height -= off;
                _tableView.frame = rect;
            }
            else
            {
                rect.origin.y -= off;
                _tableView.frame = rect;
            }
            if (off > 0)
            {
                NSInteger toff = _tableView.contentSize.height - _tableView.frame.size.height;
                if (toff < off )
                {
                    if (toff > 0)
                    {
                        _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + toff);
                    }
                }
                else
                {
                    _tableView.contentOffset = CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + off);
                }
            }
        }
    }
}

- (void)layoutRefreshScrollView {

    CGSize size = self.view.bounds.size;
    _tableView.frame = CGRectMake(0, 0, size.width, size.height - _inputView.contentHeight);
    
    [_inputView setFrameAndLayout:CGRectMake(0, size.height - _inputView.contentHeight, size.width, _inputView.contentHeight)];
//    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.left.right.equalTo(self.view);
//        make.height.mas_equalTo(self->_inputView.contentHeight);
//    }];
}

- (void)hiddenKeyBoard {
    [_inputView resignFirstResponder];
}

- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput willSendMsg:(TSIMMsg *)msg {
    if (msg)
    {
        [_tableView beginUpdates];
        NSArray *newaddMsgs = [_conversation appendWillSendMsg:msg completion:nil];
        
        NSMutableArray *array = [NSMutableArray array];
        for (TSIMMsg *newmsg in newaddMsgs)
        {
            NSInteger idx = [_messageList indexOfObject:newmsg];
            NSLog(@"---->idx = %ld",(long)idx);
            NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
            [array addObject:index];
        }
        [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *index = [NSIndexPath indexPathForRow:_messageList.count - 1 inSection:0];
            
#warning 调用 scrollToRowAtIndexPath:atScrollPosition:animated: 方法前先检查 indexPath 有没有越界
            if (index.row > 0) {
                [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        });
    }
}

- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput sendMsg:(TSIMMsg *)msg {
    [self sendMsg:msg];
    NSMutableArray *elems = [NSMutableArray array];
    for (int index = 0; index < msg.msg.elemCount; index ++) {
        [elems addObject:[msg.msg getElem:index]];
    }
    
    NSLog(@"%d", msg.msg.elemCount);
}

- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput replaceWith:(TSIMMsg *)newMsg oldMsg:(TSIMMsg *)msg {
    if (msg)
    {
        __weak TSIMChatViewController *ws = self;
        [_conversation replaceWillSendMsg:msg with:newMsg completion:^(NSArray *imamsgList, BOOL succ) {
            if (succ)
            {
                [ws onReplaceDelete:imamsgList];
            }
        }];
    }
}

- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput cancelSendMsg:(TSIMMsg *)msg {
    if (msg) {
        __weak TSIMChatViewController *ws = self;
        [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction) {
            if (succ) {
                [ws onWillRemove:imamsgList withAction:removeingAction];
            }
        }];
    }
}

- (void)onReplaceDelete:(NSArray *)replaceMsgs
{
    if (replaceMsgs.count)
    {
        [_tableView beginUpdates];
        NSMutableArray *addIndexs = [NSMutableArray array];
        for (TSIMMsg *msg in replaceMsgs)
        {
            NSInteger index = [_messageList indexOfObject:msg];
            [addIndexs addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        // 说明只是替换最后一个
        [_tableView reloadRowsAtIndexPaths:addIndexs withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *index = [NSIndexPath indexPathForRow:_messageList.count - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

- (void)onWillRemove:(NSArray *)imamsgList withAction:(CommonVoidBlock)action
{
    [_tableView beginUpdates];
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (TSIMMsg *removemsg in imamsgList)
    {
        NSInteger idx = [_messageList indexOfObject:removemsg];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexArray addObject:index];
    }
    
    if (action)
    {
        action();
    }
    
    [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView endUpdates];
}

#pragma mark - 照片&视频
- (void)onChatInputSendImage:(UIView<TSChatInputAbleView> *)chatInput {
    [self moreViewPhotoAction];
}

- (void)onChatInputRecordVideo:(UIView<TSChatInputAbleView> *)chatInput {
    [self moreVideVideoAction];
}

@end
