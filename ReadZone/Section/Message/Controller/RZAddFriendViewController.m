//
//  RZAddFriendViewController.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <IMFriendshipExt/IMFriendshipExt.h>

#import "RZAddFriendViewController.h"
#import "RZUserTextField.h"
#import "RZUserButton.h"

static CGFloat marginHorizon = 24;

@interface RZAddFriendViewController ()

@property(nonatomic,strong) UITextField *userTF;
@property(nonatomic,strong) RZUserButton *addBtn;

@end

@implementation RZAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_userTF becomeFirstResponder];
}

#pragma mark - drawView

- (void)drawNavBar {
    [super drawNavBar];
    self.title = RZLocalizedString(@"MESSAGE_NAV_ADD_FRIEND", @"添加好友页面导航栏标题【添加好友】");
}

- (void)drawView {
    _userTF = [[RZUserTextField alloc] initWithType:RZUserTextFieldTypeAccount];
    [_userTF addTarget:self action:@selector(userTFValueChange:) forControlEvents:UIControlEventEditingChanged];
    _userTF.placeholder = RZLocalizedString(@"MESSAGE_ADD_FRIEND_PLACEHOLDER", @"添加好友输入框占位符【用户名】");
    [self.view addSubview:_userTF];
    [_userTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kNavTotalHeight+marginHorizon);
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.height.mas_equalTo(40);
    }];
    
    @weakify(self);
    _addBtn = [[RZUserButton alloc] initWithTitle:RZLocalizedString(@"MESSAGE_BUTTON_ADD_FRIEND", @"添加好友页面的添加好友按钮【添加】") titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithHex:kColorUserBtnBg] onPressBlock:^{
        @strongify(self);
        [self addFriendAction];
    }];
    [self.view addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(marginHorizon);
        make.right.equalTo(self.view).with.offset(-marginHorizon);
        make.top.equalTo(self.userTF.mas_bottom).with.offset(30);
        make.height.mas_equalTo(45);
    }];
}

- (void)userTFValueChange:(RZUserTextField *)textField {
    _addBtn.enable = [NSString isEmptyString:textField.text] ? NO : YES;
}

- (void)addFriendAction {
    [self.view endEditing:YES];
    
    TIMAddFriendRequest *request = [[TIMAddFriendRequest alloc] init];
    request.identifier = [NSString stringByCuttingEdgeWhiteSpaceAndNewlineCharacterSet:_userTF.text];
    
    [[TIMFriendshipManager sharedInstance] addFriend:@[request] succ:^(NSArray *friends) {
        [self.view makeToast:[NSString stringWithFormat:@"添加 %@ 成功", self.userTF.text]];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            TIMConversation *conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:self.userTF.text];
//            
//            // 发送文本消息
//            TIMTextElem *textElem = [[TIMTextElem alloc] init];
//            textElem.text = @"测试文本";
//            TIMMessage *msg = [[TIMMessage alloc] init];
//            [msg addElem:textElem];
//            
//            @weakify(self);
//            [conversation sendMessage:msg succ:^{
//                @strongify(self);
//                NSLog(@"消息【%@】发送成功", self.userTF.text);
//                self.userTF.text = @"";
//            } fail:^(int code, NSString *msg) {
//                @strongify(self);
//                NSLog(@"消息【%@】发送失败", self.userTF.text);
//            }];
//        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(int code, NSString *msg) {
        [self.view makeToast:[NSString stringWithFormat:@"添加失败\n%d: %@", code, msg]];
    }];
}

@end
