//
//  RZRootViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

// Vendor
#import <AVOSCloud/AVOSCloud.h>

// Manager
#import "RZMenuManager.h"

// Model
#import "RZHotPotModel.h"
#import "Student.h"

// View
#import "RZNavBarItem.h"

// Controller
#import "RZRootViewController.h"

@interface RZRootViewController ()

@property(nonatomic,strong) RZMenuManager *menuManager;
@property(nonatomic,strong) UIScrollView *scrollView;

@end

@implementation RZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Draw
- (void)drawNavBar {
    [super drawNavBar];
    self.navBar.hidenBackItem = YES;
    self.title = RZLocalizedString(@"ROOT_NAV_TITLE", @"首页导航栏的标题");
    RZNavBarItem *leftItem = [RZNavBarItem navBarItemTitle:nil normalImg:[UIImage imageNamed:@"NavSearchBtn"] selectedImg:[UIImage imageNamed:@"NavSearchBtnSelected"]];
    [leftItem addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    RZNavBarItem *rightItem = [RZNavBarItem navBarItemTitle:nil normalImg:[UIImage imageNamed:@"NavMoreBtn"] selectedImg:[UIImage imageNamed:@"NavMoreBtnSelected"]];
    [rightItem addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    self.navBar.leftBarItems = @[leftItem];
    self.navBar.rightBarItems = @[rightItem];
}

- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavTotalHeight, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.scrollView];
}

#pragma mark - Action
- (void)searchAction {
    NSLog(@"ratio: %f", kScreenRatio());
    
    [RZHotPotModel registerSubclass];
    RZHotPotModel *hotPot = [[RZHotPotModel alloc] init];
    hotPot.user = [AVUser currentUser];
    hotPot.headlineStr = @"你就别担心那么多事情了，总之到哪都会牵着你。";
    hotPot.sourceStr = @"哈哈哈哈";
    
    //    AVObject *hotPot = [AVObject objectWithClassName:@"Product"];
    //    [hotPot setObject:[AVUser currentUser] forKey:@"user"];
    //    [hotPot setObject:@"你好" forKey:@"title"];
//    [Student registerSubclass];
//    Student *student = [[Student alloc] init];
//    student.name = @"谢立颖";
//    student.age = 23;
//    student.gender = GenderMale;
//    [student saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded && !error) {
//            NSLog(@"创建成功！");
//        } else {
//            NSLog(@"创建失败！");
//        }
//    }];
    
    [hotPot saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded && !error) {
            NSLog(@"创建成功！");
        } else {
            NSLog(@"创建失败！");
        }
    }];
}

- (void)moreAction {
    [self.menuManager showMenuVCWithController:self];
}

#pragma mark - Setter & Getter
- (RZMenuManager *)menuManager {
    if (!_menuManager) {
        _menuManager = [[RZMenuManager alloc] init];
    }
    return _menuManager;
}

@end
