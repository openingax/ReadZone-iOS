//
//  ViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/3.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZRootViewController.h"

@interface RZRootViewController ()

@end

@implementation RZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    testLabel.text = @"阅读空间";
    testLabel.textColor = [UIColor blackColor];
    testLabel.font = [UIFont fontWithName:@"Adobe Song Std" size:36];
    [self.view addSubview:testLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
