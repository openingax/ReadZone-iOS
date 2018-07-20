//
//  RZUserTextField.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/10.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZUserTextField.h"

@interface RZUserTextField () <UITextFieldDelegate>

@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation RZUserTextField

- (instancetype)initWithType:(RZUserTextFieldType)type {
    self == [super init];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.placeholder = RZLocalizedString(type == RZUserTextFieldTypeAccount ? @"LOGIN_PLACEHOLDER_ACCOUNT" : @"LOGIN_PLACEHOLDER_PWD", @"输入框的占位符");
        self.keyboardType = UIKeyboardTypeASCIICapable;
        
        self.secureTextEntry = type ==RZUserTextFieldTypePassword ? YES : NO;
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor blackColor];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    return YES;
}

@end
