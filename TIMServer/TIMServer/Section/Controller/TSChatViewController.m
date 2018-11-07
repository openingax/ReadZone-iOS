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

static NSString *kMsgChatCellIdentifier = @"kMsgChatCellIdentifier";

@interface TSChatViewController () <UITableViewDelegate, UITableViewDataSource, TSInputToolBarDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) TSInputToolBar *toolBar;

@end

@implementation TSChatViewController

- (instancetype)initWithUser:(TSIMUser *)user {
    if (self = [super init]) {
        _receiver = user;
    }
    return self;
}

- (void)configWithUser:(TSIMUser *)user {
    _receiver = user;
    
    TSConversationManager *manager = [[TSConversationManager alloc] init];
    _conversation = [manager chatWith:_receiver];
    _messageList = _conversation.msgList;
}

- (void)appendReceiveMessage {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = TIMLocalizedString(@"MSG_NAV_TITLE", @"留言板导航栏标题");
    
    [self drawView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didLogin {
    [self configWithUser:_receiver];
    
    [_conversation asyncLoadLocalLastMsg:^(NSArray *lastMsgs) {
        [self.currentMsgs addObjectsFromArray:lastMsgs];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveNewMsg {
    [_tableView reloadData];
}

- (void)drawView {
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGes];
    
    _toolBar = [[TSInputToolBar alloc] init];
    _toolBar.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB(247,247,247);
    [self.tableView registerClass:[TSIMMsgCell class] forCellReuseIdentifier:kMsgChatCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-self.toolBar.contentHeight);
    }];
    
    [self.view addSubview:_toolBar];
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(self.toolBar.contentHeight);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentMsgs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TSIMMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:kMsgChatCellIdentifier];
    if (!cell) {
        cell = [[TSIMMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMsgChatCellIdentifier];
    }
    
    cell.msg = [_currentMsgs objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)toolBar:(TSInputToolBar *)toolBar didClickSendButton:(NSString *)content {
    
    [self.currentMsgs addObject:content];
    [self didReceiveNewMsg];
    
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    textElem.text = content;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:textElem];
    
    TSIMMsg *imMsg = [TSIMMsg msgWithMsg:msg];
    
    [self.conversation sendMessage:imMsg completion:^(NSArray *imamsgList, BOOL succ, int code) {
        if (succ) {
            NSLog(@"消息发送成功");
            [self.toolBar setInputText:@""];
        } else {
            [self.view makeToast:[NSString stringWithFormat:@"消息发送失败\ncode: %d", code]];
        }
    }];
}

- (void)tapAction {
    [_toolBar endEditing:YES];
}

@end
