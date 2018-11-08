//
//  RZHotPotView.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/12.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZHotPotView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RZHotPotView ()

@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *essayLabel;
@property(nonatomic,strong) UILabel *authorLabel;

@end

@implementation RZHotPotView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.backgroundColor = [UIColor rz_colorwithRed:247 green:247 blue:247 alpha:1];
        [self addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIView *blurView = [[UIView alloc] init];
        blurView.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:blurView];
        [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.6*kScreenWidth, 0.5625*0.6*kScreenWidth));
            make.center.equalTo(self);
        }];
        
        self.essayLabel = [[UILabel alloc] init];
        self.essayLabel.font = kFontAdobeSongStd(16);
        self.essayLabel.textColor = [UIColor whiteColor];
        self.essayLabel.numberOfLines = 0;
        [blurView addSubview:self.essayLabel];
        [self.essayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(blurView).with.offset(12);
            make.right.equalTo(blurView).with.offset(-12);
        }];
        
        self.authorLabel = [[UILabel alloc] init];
        self.authorLabel.font = kFontAdobeSongStd(14);
        self.authorLabel.textColor = [UIColor whiteColor];
        [blurView addSubview:self.authorLabel];
        [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(blurView).with.offset(-14);
        }];
    }
    
    return self;
}

#pragma mark - Setter
- (void)setEssay:(NSString *)essay {
    if (![NSString isEmptyString:essay]) {
        self.essayLabel.text = essay;
    }
}

- (void)setAuthor:(NSString *)author {
    if (![NSString isEmptyString:author]) {
        self.authorLabel.text = [NSString stringWithFormat:@"—— 《%@》", author];
    }
}

- (void)setEssayImage:(NSString *)essayImage {
    if (![NSString isEmptyString:essayImage]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:essayImage]];
    }
}

@end
