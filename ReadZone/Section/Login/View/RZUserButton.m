//
//  RZUserButton.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/10.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZUserButton.h"
#import <MLeaksFinder/MLeaksFinder.h>

typedef void(^OnPressBlock)(void);

@interface RZUserButton ()

@property(nonatomic,copy) OnPressBlock onPressBlock;
@property(nonatomic,strong) UIColor *backgroundColor;

@end
@implementation RZUserButton

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)color
                 onPressBlock:(void(^)(void))block {
    if (self = [super init]) {
        self.layer.backgroundColor = [UIColor colorWithColor:color alpha:0.5].CGColor;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = color;
        self.onPressBlock = block;
        
        [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Action
- (void)btnAction:(UIButton *)sender {
    if (self.enable) {
        self.onPressBlock();
    }
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.layer.backgroundColor = [UIColor colorWithColor:self.backgroundColor alpha:_enable ? 1 : 0.5].CGColor;
}

@end
