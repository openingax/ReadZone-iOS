//
//  TSFriendListViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSFriendListViewController.h"
#import "TIMServerHelper.h"

@interface TSFriendListViewController ()

@end

@implementation TSFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = TIMLocalizedString(@"MSG_NAV_TITLE", @"留言板导航栏标题");
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
