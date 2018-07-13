//
//  RZMenuButton.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/13.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZMenuButton.h"

@implementation RZMenuButton

+ (RZMenuButton *)buttonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    
    // Normal state
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular] range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:attributedStr forState:UIControlStateNormal];
    // Selected state
    NSMutableAttributedString *selectedAttributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    [selectedAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, title.length)];
    [selectedAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightRegular] range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:selectedAttributedStr forState:UIControlStateSelected];
    
    return button;
}

@end
