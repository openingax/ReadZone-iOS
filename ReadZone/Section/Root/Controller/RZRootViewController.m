//
//  RZRootViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

// Vendor
#import <AVOSCloud/AVOSCloud.h>
#import <SDWebImage/UIImageView+WebCache.h>

// Manager
#import "RZMenuManager.h"

// Model
#import "RZHotPotModel.h"
#import "Student.h"
#import "RZAPIHomePage.h"

// View
#import "RZNavBarItem.h"

// Controller
#import "RZRootViewController.h"

@interface RZRootViewController ()

@property(nonatomic,strong) RZMenuManager *menuManager;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) RZAPIHomePage *homePageAPI;

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
    [self.homePageAPI fetchHomePageData:^(RZHomePageModel *data, NSError *error) {
        
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

- (RZAPIHomePage *)homePageAPI {
    if (!_homePageAPI) {
        _homePageAPI = [[RZAPIHomePage alloc] init];
    }
    return _homePageAPI;
}

@end
