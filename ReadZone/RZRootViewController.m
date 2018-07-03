//
//  RZRootViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZRootViewController.h"
#import "RZHotPotViewController.h"

@interface RZRootViewController ()

@end

@implementation RZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    self.navigationItem.title = @"阅读空间";
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavMoreBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navMoreBtnAction:)];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"NavSearchBtn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(navSearchBtnAction:)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.navigationItem.rightBarButtonItem = rightBtn;
}

#pragma mark - NFCReaderSession

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Draw
- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Action
- (void)navMoreBtnAction:(id)sender {
    NSLog(@"moreBtn pressed");
}

- (void)navSearchBtnAction:(id)sender {
    NSLog(@"searchBtn pressed");
    RZHotPotViewController *hotpotVC = [[RZHotPotViewController alloc] init];
    [self.navigationController pushViewController:hotpotVC animated:YES];
}

@end
