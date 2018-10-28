//
//  RZMsgViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/24.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZMsgViewController.h"
#import <ImSDK/ImSDK.h>
#import <IMFriendshipExt/IMFriendshipExt.h>
#import "RZUserManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface RZMsgViewController ()
<
TIMConnListener,
TIMUserStatusListener,
TIMRefreshListener,
TIMFriendshipListener,
TIMGroupListener,
TIMMessageListener
>

@property(nonatomic,strong) UITextView *msgTV;
@property(nonatomic,strong) UITextField *inputTF;

@property(nonatomic,strong) TIMConversation *conversation;

@end

@implementation RZMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
    [self configTIMAccount];
    [[TIMManager sharedInstance] addMessageListener:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loginTIM];
}

#pragma mark - DrawView

- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"MESSAGE_NAV_TITLE", @"消息根页面导航栏标题【消息】");
}

- (void)drawView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *currentUserLabel = [[UILabel alloc] init];
    currentUserLabel.text = [NSString stringWithFormat:@"当前用户：%@", [RZUserManager shareInstance].account];
    [self.view addSubview:currentUserLabel];
    [currentUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavTotalHeight + 14);
        make.centerX.equalTo(self.view);
    }];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"添加好友", @"注册", @"发送", @"同意好友"]];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.top.equalTo(currentUserLabel.mas_bottom).with.offset(28);
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
    }];
    
    self.msgTV = [[UITextView alloc] init];
    self.msgTV.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.1];
    [self.view addSubview:self.msgTV];
    [self.msgTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentControl.mas_bottom).with.offset(28);
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
        make.height.mas_equalTo(400);
    }];
    
    self.inputTF = [[UITextField alloc] init];
    self.inputTF.layer.cornerRadius = 5;
    self.inputTF.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.08];
    [self.view addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgTV.mas_bottom).with.offset(28);
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
        make.height.mas_equalTo(32);
    }];
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTF.mas_bottom).with.offset(18);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Fetch & Config
- (void)configTIMAccount {
    TIMManager *manager = [TIMManager sharedInstance];
    
    TIMSdkConfig *config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = [kTimIMSdkAppId intValue];
    config.accountType = kTimIMSdkAccountType;
    config.disableCrashReport = NO;
    config.disableLogPrint = NO;
    config.connListener = self;
    
    [manager initSdk:config];
    
    TIMUserConfig *userConfig = [[TIMUserConfig alloc] init];
    //    userConfig.disableStorage = YES;//禁用本地存储（加载消息扩展包有效）
    //    userConfig.disableAutoReport = YES;//禁止自动上报（加载消息扩展包有效）
    //    userConfig.enableReadReceipt = YES;//开启C2C已读回执（加载消息扩展包有效）
    userConfig.disableRecnetContact = NO;//不开启最近联系人（加载消息扩展包有效）
    userConfig.disableRecentContactNotify = YES;//不通过onNewMessage:抛出最新联系人的最后一条消息（加载消息扩展包有效）
    userConfig.enableFriendshipProxy = YES;//开启关系链数据本地缓存功能（加载好友扩展包有效）
    userConfig.enableGroupAssistant = YES;//开启群组数据本地缓存功能（加载群组扩展包有效）
    TIMGroupInfoOption *giOption = [[TIMGroupInfoOption alloc] init];
    giOption.groupFlags = 0xffffff;//需要获取的群组信息标志（TIMGetGroupBaseInfoFlag）,默认为0xffffff
    giOption.groupCustom = nil;//需要获取群组资料的自定义信息（NSString*）列表
    userConfig.groupInfoOpt = giOption;//设置默认拉取的群组资料
    TIMGroupMemberInfoOption *gmiOption = [[TIMGroupMemberInfoOption alloc] init];
    gmiOption.memberFlags = 0xffffff;//需要获取的群成员标志（TIMGetGroupMemInfoFlag）,默认为0xffffff
    gmiOption.memberCustom = nil;//需要获取群成员资料的自定义信息（NSString*）列表
    userConfig.groupMemberInfoOpt = gmiOption;//设置默认拉取的群成员资料
    TIMFriendProfileOption *fpOption = [[TIMFriendProfileOption alloc] init];
    fpOption.friendFlags = 0xffffff;//需要获取的好友信息标志（TIMProfileFlag）,默认为0xffffff
    fpOption.friendCustom = nil;//需要获取的好友自定义信息（NSString*）列表
    fpOption.userCustom = nil;//需要获取的用户自定义信息（NSString*）列表
    userConfig.friendProfileOpt = fpOption;//设置默认拉取的好友资料
    userConfig.userStatusListener = self;//用户登录状态监听器
    userConfig.refreshListener = self;//会话刷新监听器（未读计数、已读同步）（加载消息扩展包有效）
    //    userConfig.receiptListener = self;//消息已读回执监听器（加载消息扩展包有效）
    //    userConfig.messageUpdateListener = self;//消息svr重写监听器（加载消息扩展包有效）
    //    userConfig.uploadProgressListener = self;//文件上传进度监听器
    //    userConfig.groupEventListener todo
    //    userConfig.messgeRevokeListener = self.conversationMgr;
    userConfig.friendshipListener = self;//关系链数据本地缓存监听器（加载好友扩展包、enableFriendshipProxy有效）
    userConfig.groupListener = self;//群组据本地缓存监听器（加载群组扩展包、enableGroupAssistant有效）
    
    int setConfigStatus = [manager setUserConfig:userConfig];
    NSLog(@"setConfigStatus: %d", setConfigStatus);
}

- (void)loginTIM {
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.identifier = [NSString stringWithFormat:@"%@", [RZUserManager shareInstance].account];
    
    param.userSig = [RZUserManager shareInstance].sig;
    
    param.appidAt3rd = kTimIMSdkAppId;
    
    @weakify(self);
    [[TIMManager sharedInstance] login:param succ:^{
        @strongify(self);
        [self registNotification];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"登录成功"];
        
    } fail:^(int code, NSString *msg) {
        @strongify(self);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:[@"登录失败\n" stringByAppendingString:msg]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

#pragma mark - Notification

- (void)registNotification
{
    if (@available(iOS 8, *)) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

#pragma mark - TIMMessageListener
- (void)onNewMessage:(NSArray *)msgs {
    NSLog(@"收到了新消息：%@", msgs);
    NSString *msg = @"";
    for (int i = 0; i < msgs.count; i ++) {
        TIMMessage *message = [msgs objectAtIndex:i];
        
        for (int j = 0; j < message.elemCount; j++) {
            TIMElem *elem = [message getElem:j];
            if ([elem isKindOfClass:[TIMTextElem class]]) {
                TIMTextElem *textElem = (TIMTextElem *)elem;
                msg = [msg stringByAppendingString:textElem.text];
                
            } else if ([elem isKindOfClass:[TIMImageElem class]]) {
                
            } else if ([elem isKindOfClass:[TIMFileElem class]]) {
                
            } else if ([elem isKindOfClass:[TIMSoundElem class]]) {
                
            } else if ([elem isKindOfClass:[TIMLocationElem class]]) {
                
            } else if ([elem isKindOfClass:[TIMCustomElem class]]) {
                
            } else if ([elem isKindOfClass:[TIMFaceElem class]]) {
                
            }
        }
    }
    
    self.msgTV.text = [NSString stringWithFormat:@"%@\n%@", self.msgTV.text, msg];
}

#pragma mark - Action

- (void)segmentControlAction:(UISegmentedControl *)segmentControl {
    NSInteger selectedIndex = segmentControl.selectedSegmentIndex;
    
    if (selectedIndex == 0) {
        
        // 添加朋友
        TIMAddFriendRequest *request = [[TIMAddFriendRequest alloc] init];
        request.identifier = self.inputTF.text;
        request.remark = @"无";
        request.addWording = @"请求说明";
        request.friendGroup = @"";
        
        [[TIMFriendshipManager sharedInstance] addFriend:@[request] succ:^(NSArray *friends) {
            NSLog(@"friends: %@", friends);
        } fail:^(int code, NSString *msg) {
            NSLog(@"add friend failed code: %d, msg: %@", code, msg);
        }];
        
    } else if (selectedIndex == 1) {
        
        // 注册
        
    } else if (selectedIndex == 2) {
        
        
    } else {
        TIMFriendResponse *response = [[TIMFriendResponse alloc] init];
        response.identifier = [[RZUserManager shareInstance].account isEqualToString:@"18814098638"] ? @"13265028638" : @"18814098638";
        response.remark = @"谢立颖的大号";
        response.responseType = TIM_FRIEND_RESPONSE_AGREE_AND_ADD;
        
        [[TIMFriendshipManager sharedInstance] doResponse:@[response] succ:^(NSArray *friends) {
            
        } fail:^(int code, NSString *msg) {
            
        }];
    }
}

- (void)sendAction {
    
    if (!self.conversation) {
        self.conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[[RZUserManager shareInstance].account isEqualToString:@"18814098638"] ? @"13265028638" : @"18814098638"];
    }
    
    // 发送文本消息
    TIMTextElem *textElem = [[TIMTextElem alloc] init];
    textElem.text = self.inputTF.text;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:textElem];
    
    @weakify(self);
    [self.conversation sendMessage:msg succ:^{
        @strongify(self);
        NSLog(@"消息【%@】发送成功", self.inputTF.text);
        self.inputTF.text = @"";
    } fail:^(int code, NSString *msg) {
        @strongify(self);
        NSLog(@"消息【%@】发送失败", self.inputTF.text);
    }];
    
}

@end
