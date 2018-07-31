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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImageView *topImgView;
    for (int i = 1; i < 100; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://s.stbzd.cn/xiezhen/20170626yuss%d.jpg", i]]];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://nwzimg.wezhan.cn/contents/sitefiles2019/10097233/images/24137%d.jpg", i]]];
        [self.scrollView addSubview:imgView];
        if (i == 1) {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView);
                make.centerX.equalTo(self.scrollView);
                make.size.mas_equalTo(CGSizeMake(375, 562));
            }];
        } else if (i == 99) {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topImgView.mas_bottom).with.offset(20);
                make.centerX.equalTo(self.scrollView);
                make.size.mas_equalTo(CGSizeMake(375, 562));
                make.bottom.equalTo(self.scrollView).with.offset(10);
            }];
        } else {
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topImgView.mas_bottom).with.offset(10);
                make.centerX.equalTo(self.scrollView);
                make.size.mas_equalTo(CGSizeMake(375, 562));
            }];
        }
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.text = [NSString stringWithFormat:@"No: %d", i];
        indexLabel.textColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.6];
        indexLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        [imgView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(imgView).with.offset(8);
        }];
        
        topImgView = imgView;
    }
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
