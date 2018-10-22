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
#import "RZHotPotView.h"

// Controller
#import "RZRootViewController.h"

@interface RZRootViewController ()

@property(nonatomic,strong) RZMenuManager *menuManager;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) RZHotPotView *hotPotView;

@property(nonatomic,strong) RZAPIHomePage *homePageAPI;

@end

@implementation RZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appLoginNoti) name:kLoginSuccessNotification object:nil];
    if ([AVUser currentUser]) [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgeGesture:)];
    edgeGes.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgeGes];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavTotalHeight, kScreenWidth, kScreenHeight-kNavTotalHeight)];
    [self.view addSubview:self.scrollView];
    
    self.hotPotView = [[RZHotPotView alloc] init];
    [self.scrollView addSubview:self.hotPotView];
    [self.hotPotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.centerX.equalTo(self.scrollView);
        make.height.mas_equalTo(9*kScreenWidth/16);
    }];
}

#pragma mark - Notification
- (void)appLoginNoti {
    [self fetchData];
}

#pragma mark - Fetch
- (void)fetchData {
    @weakify(self);
    [self.homePageAPI fetchHomePageData:^(RZHomePageModel *data, NSError *error) {
        @strongify(self);
        self.hotPotView.essay = data.essay;
        self.hotPotView.author = data.author;
        self.hotPotView.essayImage = data.essayImage;
    }];
}

#pragma mark - Action
- (void)edgeGesture:(UIGestureRecognizer *)gesture {
    [self moreAction];
}

- (void)searchAction {
    NSLog(@"ratio: %f", kScreenRatio());
    [self fetchData];
//    [self.homePageAPI fetchHomePageData:^(RZHomePageModel *data, NSError *error) {
//
//    }];
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
