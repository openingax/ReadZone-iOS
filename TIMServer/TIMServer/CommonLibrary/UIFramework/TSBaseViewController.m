//
//  TSBaseViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseViewController.h"

#import "UIViewController+Layout.h"
#import "TSDevice.h"

@interface TSBaseViewController ()

@end

@implementation TSBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configParams];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layoutOnViewDidAppear];
}

- (void)configParams {
    
}


#pragma mark -
- (BOOL)hasBackgroundView {
    return NO;
}

- (void)addBackground {
    
}

- (void)configBackground {
    
}

- (void)layoutBackground {
    
}

@end
