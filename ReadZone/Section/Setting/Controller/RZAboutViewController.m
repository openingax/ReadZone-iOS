//
//  RZAboutViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/13.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAboutViewController.h"

@interface RZAboutViewController ()

@end

@implementation RZAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"ABOUT_NAV_TITLE", @"关于页面导航栏标题【关于】");
}

- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
