//
//  RZHotPotViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/29.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZHotPotViewController.h"

@interface RZHotPotViewController ()

@end

@implementation RZHotPotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavSearchBtn"] style:UIBarButtonItemStyleDone target:self action:@selector(popVCAction)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popVCAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
