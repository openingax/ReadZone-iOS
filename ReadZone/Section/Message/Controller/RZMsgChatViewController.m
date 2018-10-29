//
//  RZMsgChatViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZMsgChatViewController.h"
#import "TIMUserProfile+RZ.h"

@interface RZMsgChatViewController ()

@end

@implementation RZMsgChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
}

- (void)drawNavBar {
    [super drawNavBar];
    self.title = [self.conversaion getReceiver];
}

- (void)drawView {
    
}

@end
