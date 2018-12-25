//
//  TSIMChatViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMChatViewController.h"
#import "PathUtility.h"

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [self.KVOController unobserveAll];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didConversationExist {
    [super didConversationExist];
    
    // 处理草稿
    TSIMMsg *draftMsg = [TSIMMsg msgWithDraft:[_conversation getLocalDraft]];
    [_inputView setMsgDraft:draftMsg];
}

- (void)didTIMServerExit {
    TSIMMsg *draft = [_inputView getMsgDraft];
    if (draft) {
        [_conversation setLocalDraft:draft.msgDraft];
    } else {
        [_conversation setLocalDraft:nil];
    }
    
    [super didTIMServerExit];
}

#pragma mark - Notification
- (void)onRevokeMsg:(NSNotification *)notify {
    if ([notify.object isKindOfClass:[TSIMMsg class]])//本地撤回
    {
        TSIMMsg *msg = (TSIMMsg *)notify.object;
        __weak typeof(self) ws = self;
        [_conversation revokeMsg:msg isRemote:NO completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction) {
            if (succ)
            {
                [ws onWillRefresh:imamsgList withAction:removeingAction];
            }
        }];
    }
    else if ([notify.object isKindOfClass:[TIMMessageLocator class]])//接收到撤回消息
    {
        TSIMMsg *msg = [self findMsg:(TIMMessageLocator *)notify.object];
        if (!msg) {
            return;
        }
        __weak typeof(self) ws = self;
        [_conversation revokeMsg:msg isRemote:YES completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removeingAction) {
            if (succ)
            {
                [ws onWillRefresh:imamsgList withAction:removeingAction];
            }
        }];
    }
}

- (TSIMMsg *)findMsg:(TIMMessageLocator *)locator
{
    for (TSIMMsg *imaMsg in _messageList.safeArray)
    {
        if ([imaMsg.msg respondsToLocator:locator])
        {
            return imaMsg;
        }
    }
    return nil;
}

- (void)onDeleteMsg:(NSNotification *)noti {
    TSIMMsg *msg = (TSIMMsg *)noti.object;
    __weak TSIMChatViewController *ws = self;
    [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
        if (succ)
        {
            [ws onWillRemove:imamsgList withAction:removingAction];
        }
    }];
}

- (void)onResendMsg:(NSNotification *)noti {
    TSIMMsg *msg = (TSIMMsg *)noti.object;
    
    if (msg.type == TSIMMsgTypeImage) {
        TIMImageElem *elem = (TIMImageElem *)[msg.msg getElem:0];
        elem.path = [NSString stringWithFormat:@"%@%@", [PathUtility getTemporaryPath], [elem.path substringFromIndex:[PathUtility getTemporaryPath].length]];
        
        TIMImageElem *newElem = [[TIMImageElem alloc] init];
        newElem.path = elem.path;
        newElem.level = elem.level;
        
        TIMMessage *timMsg = [[TIMMessage alloc] init];
        [timMsg addElem:newElem];
        
        TSIMMsg *newMsg = [TSIMMsg msgWithMsg:timMsg];
        
        __weak TSIMChatViewController *ws = self;
        [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
            if (succ)
            {
                [ws onWillRemove:imamsgList withAction:removingAction];
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendMsg:newMsg];
        });
        
    } else if (msg.type == TSIMMsgTypeVideo) {
        
        TIMUGCElem *elem = (TIMUGCElem *)[msg.msg getElem:0];
        elem.videoPath = [NSString stringWithFormat:@"%@%@", [PathUtility getTemporaryPath], [elem.videoPath substringFromIndex:[PathUtility getTemporaryPath].length]];
        elem.coverPath = [NSString stringWithFormat:@"%@%@", [PathUtility getTemporaryPath], [elem.coverPath substringFromIndex:[PathUtility getTemporaryPath].length]];
        
        TIMUGCElem *newElem = [[TIMUGCElem alloc] init];
        newElem.video = elem.video;
        newElem.videoPath = elem.videoPath;
        newElem.cover = elem.cover;
        newElem.coverPath = elem.coverPath;
        
        TIMMessage *timMsg = [[TIMMessage alloc] init];
        [timMsg addElem:newElem];
        
        TSIMMsg *newMsg = [TSIMMsg msgWithMsg:timMsg];
        
        __weak TSIMChatViewController *ws = self;
        [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
            if (succ)
            {
                [ws onWillRemove:imamsgList withAction:removingAction];
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendMsg:newMsg];
        });
        
    } else {
        
        __weak TSIMChatViewController *ws = self;
        [_conversation removeMsg:msg completion:^(NSArray *imamsgList, BOOL succ, CommonVoidBlock removingAction) {
            if (succ)
            {
                [ws onWillRemove:imamsgList withAction:removingAction];
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendMsg:msg];
        });
    }
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
    NSInteger newValue = [change[NSKeyValueChangeNewKey] integerValue];
    NSInteger oldValue = [change[NSKeyValueChangeOldKey] integerValue];
    
    if (newValue != oldValue) {
        NSInteger off = newValue - oldValue;
        CGRect rect = self.tableView.frame;
        
        if (rect.origin.y == 0) {
            rect.size.height -= off;
            _tableView.frame = rect;
        } else {
            rect.origin.y -= off;
            _tableView.frame = rect;
        }
        
        if (off > 0) {
            // 弹出键盘
            _tableView.contentOffset = CGPointMake(0, _tableView.contentSize.height - (kScreenHeight - newValue));
        } else {
            // 收起键盘
        }
    }
}

// 对会话的 tableView 与输入框做布局
- (void)layoutRefreshScrollView {
    
    CGSize size = self.view.bounds.size;
    _tableView.frame = CGRectMake(0, 0, size.width, size.height - _inputView.contentHeight);
    
    [_inputView setFrameAndLayout:CGRectMake(0, size.height - _inputView.contentHeight, size.width, _inputView.contentHeight)];
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

- (void)onWillRefresh:(NSArray *)imamsgList withAction:(CommonVoidBlock)action
{
    [_tableView beginUpdates];
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (TSIMMsg *removemsg in imamsgList)
    {
        NSInteger idx = [_messageList indexOfObject:removemsg];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexArray addObject:index];
    }
    
    [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableView endUpdates];
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
    
    [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationLeft];
    
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
