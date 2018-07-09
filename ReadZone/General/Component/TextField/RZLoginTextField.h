//
//  RZLoginTextField.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/9.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RZLoginTextFieldType) {
    RZLoginTextFieldTypeAccount = 0,        // 帐户输入框
    RZLoginTextFieldTypePassword            // 密码输入框
};

@interface RZLoginTextField : UITextField

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithType:(RZLoginTextFieldType)type;

@end
