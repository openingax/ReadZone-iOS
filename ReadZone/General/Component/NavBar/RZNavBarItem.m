//
//  RZNavBarItem.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/8.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZNavBarItem.h"

@implementation RZNavBarItem

+ (instancetype)navBarItemWithType:(RZNavBarItemType)itemType {
    RZNavBarItem *item = [RZNavBarItem buttonWithType:UIButtonTypeCustom];
    item.itemType = itemType;
    item.itemWidth = 44.f;
    if (itemType == RZNavBarItemTypeBack) {
        item.normalImg = [UIImage imageNamed:@"nav_bar_back_icon"];
        item.selectedImg = [UIImage alphaImage:[UIImage imageNamed:@"nav_bar_back_icon"] withAlpha:0.7f] ;
        [item setImage:item.normalImg forState:UIControlStateNormal];
        [item setImage:item.selectedImg forState:UIControlStateHighlighted];
        [item setImage:item.selectedImg forState:UIControlStateSelected];
    }
    return item;
}

+ (instancetype)navBarItemTitle:(NSString *)title normalImg:(UIImage *)normalImg selectedImg:(UIImage *)selectedImg {
    RZNavBarItem *item = [RZNavBarItem navBarItemWithType:RZNavBarItemTypeNormal];
    if (IsEmpty(selectedImg)) {
        selectedImg = normalImg;
    }
    item.normalImg = normalImg;
    item.selectedImg = [UIImage alphaImage:selectedImg withAlpha:0.7f];
    item.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    [item setImage:item.normalImg forState:UIControlStateNormal];
    [item setImage:item.selectedImg forState:UIControlStateSelected];
    [item setImage:item.selectedImg forState:UIControlStateHighlighted];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
    [item setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateSelected];
    
    return item;
}

+ (instancetype)navBarItemTitle:(NSString *)title {
    RZNavBarItem *item = [RZNavBarItem navBarItemTitle:title normalImg:nil selectedImg:nil];
    return item;
}

- (void)updateConstraints{
    [super updateConstraints];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.itemWidth);
        make.height.mas_equalTo(44);
    }];
}

@end
