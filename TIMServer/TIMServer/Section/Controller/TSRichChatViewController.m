//
//  TSRichChatViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/27.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSRichChatViewController.h"

@interface TSRichChatViewController ()

@end

@implementation TSRichChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 发送没有新消息的通知，消息冰箱 RN 界面的小红点
    [[NSNotificationCenter defaultCenter] postNotificationName:kTIMNewMsgEvent object:nil userInfo:@{@"status" : @(NO)}];
}

- (void)dealloc {
    NSLog(@"TSRichChatViewController dealloc");
}

- (void)addInputPanel {
    _inputView = [[TSRichChatInputPanel alloc] initRichChatInputPanel];
    _inputView.chatDelegate = self;
    [self.view addSubview:_inputView];
}

@end
