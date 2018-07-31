//
//  RZUserTextField.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/10.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZUserTextField.h"

@interface RZUserTextField () <UITextFieldDelegate>

@property(nonatomic,assign) RZUserTextFieldType type;

@property(nonatomic,strong) UILabel *placeholderLabel;

@property(nonatomic,strong) UIView *bottomLine;

@end

@implementation RZUserTextField

- (instancetype)initWithType:(RZUserTextFieldType)type {
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.secureTextEntry = type ==RZUserTextFieldTypePassword ? YES : NO;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        // 处理占位符
        [self addSubview:self.placeholderLabel];
        self.placeholderLabel.text = RZLocalizedString(self.type == RZUserTextFieldTypeAccount ? @"LOGIN_PLACEHOLDER_ACCOUNT" : @"LOGIN_PLACEHOLDER_PWD", @"输入框的占位符");
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
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

#pragma mark - Event
- (void)textFieldDidChange:(UITextField *)textField {
    if ([NSString checkIsEmptyOrNull:textField.text]) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.centerY.equalTo(self);
            }];
            self.placeholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        }];
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.equalTo(self).with.offset(-10);
            }];
            self.placeholderLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.6 animations:^{
        [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1.5);
        }];
        self.bottomLine.backgroundColor = [UIColor blackColor];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([NSString checkIsEmptyOrNull:textField.text]) {
        [UIView animateWithDuration:0.8 animations:^{
            [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.centerY.equalTo(self);
            }];
            self.placeholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
            
            [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.5);
            }];
            self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
        }];
    } else {
        [UIView animateWithDuration:0.8 animations:^{
            [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0.5);
            }];
            self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignFirstResponder];
    return YES;
}

#pragma mark - Setter & Getter
- (void)setPlaceholder:(NSString *)placeholder {
    if ([NSString checkIsEmptyOrNull:placeholder]) {
        self.placeholderLabel.text = RZLocalizedString(self.type == RZUserTextFieldTypeAccount ? @"LOGIN_PLACEHOLDER_ACCOUNT" : @"LOGIN_PLACEHOLDER_PWD", @"输入框的占位符");
    } else {
        self.placeholderLabel.text = placeholder;
    }
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor rz_colorwithRed:153 green:150 blue:153 alpha:1];
        _placeholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    }
    return _placeholderLabel;
}

@end
