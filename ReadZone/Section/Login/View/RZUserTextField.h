//
//  RZUserTextField.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/10.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RZUserTextFieldType) {
    RZUserTextFieldTypeAccount = 0,         // 帐户输入
    RZUserTextFieldTypePassword,            // 密码输入
    RZUserTextFieldTypeAuthCode             // 验证码输入
};

@interface RZUserTextField : UITextField

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithType:(RZUserTextFieldType)type;

@end
