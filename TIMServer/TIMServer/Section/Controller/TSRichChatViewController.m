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
    
    // 处理草稿
}

- (void)dealloc {
    
}

- (void)addInputPanel {
    _inputView = [[TSRichChatInputPanel alloc] initRichChatInputPanel];
    _inputView.chatDelegate = self;
    [self.view addSubview:_inputView];
}

@end
