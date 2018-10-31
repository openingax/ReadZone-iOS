//
//  RZMsgChatViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZMsgChatViewController.h"
#import "TIMUserProfile+RZ.h"
#import <TIMServer/TIMServer.h>

@interface RZMsgChatViewController ()

@property(nonatomic,strong) TSInputToolBar *toolBar;

@end

@implementation RZMsgChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)drawNavBar {
    [super drawNavBar];
    self.title = [self.conversaion getReceiver];
}

- (void)drawView {
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGes];
    
    _toolBar = [[TSInputToolBar alloc] init];
    [self.view addSubview:_toolBar];
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(self.toolBar.contentHeight);
    }];
}

#pragma mark - Action

- (void)tapAction {
    [_toolBar endEditing:YES];
}

@end
