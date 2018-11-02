//
//  RZMsgChatViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZMsgChatViewController.h"
#import "TIMUserProfile+RZ.h"
#import "RZConversationManager.h"

@interface RZMsgChatViewController () <TSInputToolBarDelegate>

@property(nonatomic,strong) TSInputToolBar *toolBar;

@end

@implementation RZMsgChatViewController

#pragma mark - Init & Config

- (instancetype)initWithUser:(RZIMUser *)user {
    if (self = [super init]) {
        _receiver = user;
    }
    return self;
}

- (void)configWithUser:(RZIMUser *)user {
    _receiver = user;
    
    RZConversationManager *manager = [[RZConversationManager alloc] init];
    _conversation = [manager chatWith:_receiver];
    _messageList = _conversation.msgList;
}

- (void)appendReceiveMessage {
    
}

#pragma mark - Life

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configWithUser:_receiver];
    [self drawView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_toolBar) {
        _toolBar.isPoping = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _toolBar.isPoping = YES;
}

- (void)drawNavBar {
    [super drawNavBar];
    self.title = _receiver.userId;
}

- (void)drawView {
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGes];
    
    _toolBar = [[TSInputToolBar alloc] init];
    _toolBar.delegate = self;
    [self.view addSubview:_toolBar];
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(self.toolBar.contentHeight);
    }];
}

#pragma mark - TSInputToolBarDelegate

- (void)toolBar:(TSInputToolBar *)toolBar didClickSendButton:(NSString *)content {
    // 发送文本消息
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    textElem.text = content;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:textElem];
    
    
    RZIMMsg *imMsg = [RZIMMsg msgWithMsg:msg];
    
    @weakify(self);
    [self.conversation sendMessage:imMsg completion:^(NSArray *imamsgList, BOOL succ, int code) {
        @strongify(self);
        if (succ) {
            NSLog(@"消息发送成功");
            [self.toolBar setInputText:@""];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"消息发送失败\ncode: %d", code]];
        }
    }];
}

#pragma mark - Action

- (void)tapAction {
    [_toolBar endEditing:YES];
}

@end
