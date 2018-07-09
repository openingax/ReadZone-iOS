//
//  RZLoginTextField.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/9.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZLoginTextField.h"

@interface RZLoginTextField () <UITextFieldDelegate>

@end

@implementation RZLoginTextField

- (instancetype)initWithType:(RZLoginTextFieldType)type {
    if (self == [super init]) {
        self.delegate = self;
        if (type == RZLoginTextFieldTypeAccount) {
            self.placeholder = @"";
        }
    }
    
    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

@end
