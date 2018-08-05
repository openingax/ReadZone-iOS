//
//  AppDelegate.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/6/3.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Bugly/Bugly.h>

#import "AppDelegate.h"
#import "RZAPI.h"
#import "RZAPIUser.h"

#import "RZUserInfoModel.h"
#import "RZUserModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (instancetype)shared {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Bug 统计
    [Bugly startWithAppId:@"c80362e8b9"];
    
    // leanCloud 云服务
    [AVOSCloud setApplicationId:@"2qF4yFo6bwYFQzwB3ox2mhNP-gzGzoHsz" clientKey:@"QYnp3ODfDQ0RSta9tWJd7ugi"];
    [AVOSCloud setAllLogsEnabled:YES];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];        // 跟踪统计应用的打开情况
    [AVAnalytics setChannel:kAppDevelopMode ? @"开发环境" : @"蒲公英分发平台"];
    
    // 初始化视图控制器
    RZRootViewController *rootVC = [[RZRootViewController alloc] init];
    RZBaseNavigationController *rootNav = [[RZBaseNavigationController alloc] initWithRootViewController:rootVC];
    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    
    [AVUser currentUser] ? [self fetchUserInfo] : [self showLoginVC];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Getter
- (RZBaseNavigationController *)navigationController {
    if (!_navigationController) {
        _navigationController = [[RZBaseNavigationController alloc] init];
    }
    return _navigationController;
}

- (RZRootViewController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [[RZRootViewController alloc] init];
    }
    return _rootViewController;
}

- (RZLoginViewController *)loginViewController {
    if (!_loginViewController) {
        _loginViewController = [[RZLoginViewController alloc] init];
    }
    return _loginViewController;
}

- (void)showLoginVC {
    RZLoginViewController *loginVC = [[RZLoginViewController alloc] init];
    RZBaseNavigationController *loginNav = [[RZBaseNavigationController alloc] initWithRootViewController:loginVC];
    [self.window.rootViewController presentViewController:loginNav animated:NO completion:nil];
}

- (void)fetchUserInfo {
    RZAPIUser *userAPI = [[RZAPIUser alloc] init];
    [userAPI fetchUserInfoWithBlock:^(RZUserModel *userInfo, NSError *error) {
        if (!error) {
            [RZUser shared].userInfo = userInfo;
        } else {
            [AVUser logOut];
            [self showLoginVC];
        }
    }];
}

@end
