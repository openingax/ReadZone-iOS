//
//  RZSettingViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/13.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

// Vendor
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

// Manager
#import "AppDelegate.h"

// View
#import "RZSettingCell.h"

// Controller
#import "RZSettingViewController.h"
#import "RZAboutViewController.h"
#import "RZLoginViewController.h"
#import "RZBaseNavigationController.h"

static NSString * const kSettingCellIdentifier = @"kRZSettingCellIdentifier";

@interface RZSettingViewController () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSIndexPath *selectedIndexPath;
@property(nonatomic,assign) BOOL isUpdateAvatarImg;
@property(nonatomic,strong) UIImage *avatarImg;

@end

@implementation RZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    self.selectedIndexPath = nil;
    self.avatarImg = nil;
    self.isUpdateAvatarImg = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginEvent:) name:kLoginSuccessNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.selectedIndexPath && self.tableView) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Event
- (void)loginEvent:(NSNotification *)noti {
    [self.tableView reloadData];
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
            if (self.isUpdateAvatarImg) {
                [cell.avatarImgView sd_setImageWithURL:[NSURL URLWithString:[RZUser shared].userInfo.userAvatar] placeholderImage:self.avatarImg];
            } else {
                cell.avatarImgView.image = self.avatarImg;
            }
        } else {
            // 常规设置
            switch (indexPath.row) {
                case 1:
                    cell.title = RZLocalizedString(@"SETTING_CELL_USERNAME", @"设置页的用户名【用户名】");
                    cell.detail = [RZUser shared].userInfo.userName;
                    break;
                case 2:
                    cell.title = RZLocalizedString(@"SETTING_CELL_ACCOUNT", @"设置页_帐户【帐户】");
                    cell.detail = [RZUser shared].userInfo.account;
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
            case 0: {
                // 进入相册选择页面
                [self takePhoto];
            } break;
            case 1: break;
            case 2: break;
            case 3:{
                RZAboutViewController *aboutVC = [[RZAboutViewController alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 4: break;
            case 5: break;
            case 6: {
                [AVFile clearAllPersistentCache];
            } break;
                
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
            [AVUser logOut];                        // 登出
            [RZUser shared].userInfo = nil;         // 清空用户数据
            RZLoginViewController *loginVC = [[RZLoginViewController alloc] init];
            RZBaseNavigationController *navVC = [[RZBaseNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:navVC animated:YES completion:nil];
        }];
        
        [alert addAction:logoutAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.isUpdateAvatarImg = NO;
    self.avatarImg = [photos objectAtIndex:0];
    [self.tableView reloadData];
    
    @weakify(self);
    NSData *imgData = UIImagePNGRepresentation(self.avatarImg);
    AVFile *imgFile = [AVFile fileWithData:imgData name:[NSString stringWithFormat:@"%@_avatar", [AVUser currentUser].objectId]];
    [imgFile uploadWithProgress:^(NSInteger number) {
        NSLog(@"用户头像上传进度：%lu\n", (long)number);
    } completionHandler:^(BOOL succeeded, NSError * _Nullable error) {
        @strongify(self);
        
        /* 不管上传成功或失败，都发通知去刷新头像的数据
         * 如果上传成功，则头像的 imgView 会用新的 url 加载新头像
         * 如果上传失败，则头像的 imgView 用回旧的 url 加载旧头像
         */
        self.isUpdateAvatarImg = YES;
        if (succeeded) {
            NSLog(@"用户头像上传成功\n");
            [RZUser shared].userInfo.userAvatar = imgFile.url;
            // 头像上传成功后，更新服务端当前用户下的 UserInfo 对应的 userAvatar 数据
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:[RZUser shared].userInfo];
    }];
}

#pragma mark - Private
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
//        if (iOS8Later) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
//        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
//        if (iOS8Later) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//            [alert show];
//        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePicker.isSelectOriginalPhoto = NO;
        imagePicker.allowTakePicture = YES;
        imagePicker.allowTakeVideo = NO;
        imagePicker.needCircleCrop = NO;
        imagePicker.circleCropRadius = kScreenWidth/2;
//        imagePicker.cropRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        imagePicker.iconThemeColor = [UIColor colorWithHex:kColorNavTitle];
        imagePicker.allowCrop = YES;
//        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

@end
