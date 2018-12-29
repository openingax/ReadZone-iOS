//
//  RZBaseViewController.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/29.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZNavBar.h"
#import <Masonry/Masonry.h>

@interface RZBaseViewController : UIViewController

@property(nonatomic, strong) RZNavBar *navBar;

#pragma mark - navBar
- (void)drawNavBar;
- (void)drawNavBarItems;

- (void)popSelfWithSomeActions;

@end
