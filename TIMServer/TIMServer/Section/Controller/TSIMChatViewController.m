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
    // 处理草稿
    
    // 注册消息相关的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRevokeMsg:) name:kIMAMSG_RevokeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeleteMsg:) name:kIMAMSG_DeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResendMsg:) name:kIMAMSG_ResendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangedMsg:) name:kIMAMSG_ChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    
    // 处理草稿
    TSIMMsg *draft = [_inputView getMsgDraft];
    if (draft) {
        
    }
    
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
    _inputView = [[TSRichChatInputPanel alloc] initRichChatInputPanel];
    _inputView.chatDelegate = self;
    [self.view addSubview:_inputView];
    
    self.view.backgroundColor = [UIColor redColor];
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
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(self->_inputView.contentHeight);
    }];
}

- (void)hiddenKeyBoard {
    [_inputView resignFirstResponder];
}

- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput sendMsg:(TSIMMsg *)msg {
    
}

@end
