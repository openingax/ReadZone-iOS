//
//  RZSettingViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/13.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZSettingViewController.h"
#import "RZSettingCell.h"
#import "RZAboutViewController.h"

static NSString * const kSettingCellIdentifier = @"kRZSettingCellIdentifier";

@interface RZSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end

@implementation RZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    self.selectedIndexPath = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.selectedIndexPath && self.tableView) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}

#pragma mark - DrawView
- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"SETTING_NAV_SETTING", @"设置页导航栏标题【设置】");
}

- (void)drawView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavTotalHeight, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    [self.tableView registerClass:[RZSettingCell class] forCellReuseIdentifier:kSettingCellIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavTotalHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDeletate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 7 : section == 1 ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 && indexPath.row == 0 ? 100 : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RZSettingCellType type = indexPath.section == 0 && indexPath.row == 0 ? RZSettingCellTypeAvatar : indexPath.section == 2 ? RZSettingCellTypeDelete : RZSettingCellTypeNormal;
    RZSettingCell *cell = [[RZSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSettingCellIdentifier cellType:type];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 头像
            cell.avatarImgUrl = @"http://lc-2qF4yFo6.cn-n1.lcfile.com/057b75f6dac78e0f6d54.JPG";
        } else {
            // 常规设置
            switch (indexPath.row) {
                case 1:
                    cell.title = RZLocalizedString(@"SETTING_CELL_USERNAME", @"设置页的用户名【用户名】");
                    cell.detail = @"X-LYing";
                    break;
                case 2:
                    cell.title = RZLocalizedString(@"SETTING_CELL_ACCOUNT", @"设置页_帐户【帐户】");
                    cell.detail = @"18814098638";
                    break;
                case 3: cell.title = RZLocalizedString(@"SETTING_CELL_ABOUT", @"设置页_关于【关于】"); break;
                case 4: cell.title = RZLocalizedString(@"SETTING_CELL_HELP", @"设置页_帮助【帮助】");
                    break;
                case 5: cell.title = RZLocalizedString(@"SETTING_CELL_FEEDBACK", @"设置页_反馈【反馈】"); break;
                case 6: cell.title = RZLocalizedString(@"SETTING_CELL_CLEARCACHE", @"设置页_清除缓存【清除缓存】"); break;
            }
        }
    } else if (indexPath.section == 1) {
        // 用户协议类
        NSString *title = indexPath.row == 0 ? RZLocalizedString(@"SETTING_CELL_PROTOCOL", @"设置页_用户协议【用户协议】"): RZLocalizedString(@"SETTING_CELL_PRIVACY", @"设置页_隐私政策【隐私政策】");
        cell.title = title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) {
        self.selectedIndexPath = indexPath;
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: break;
            case 1: break;
            case 2: break;
            case 3:{
                RZAboutViewController *aboutVC = [[RZAboutViewController alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 4: break;
            case 5: break;
            case 6: break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        // 用户协议类
    } else {
        // 退出登录
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:RZLocalizedString(@"SETTING_CANCEL", @"设置页【取消】") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:RZLocalizedString(@"SETTING_CELL_LOGOUT", @"设置页【登出】") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:logoutAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
