//
//  RZSettingCell.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/13.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZSettingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RZSettingCell ()

//@property(nonatomic,strong) UIImageView *avatarImgView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *detailLabel;

@end

@implementation RZSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(RZSettingCellType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self drawViewWithType:type];
    }
    return self;
}

- (void)drawViewWithType:(RZSettingCellType)type {
    if (type == RZSettingCellTypeAvatar) {
        self.avatarImgView = [[UIImageView alloc] init];
        self.avatarImgView.backgroundColor = [UIColor lightGrayColor];
        self.avatarImgView.layer.cornerRadius = 30;
        self.avatarImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImgView];
        [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
    } else if (type == RZSettingCellTypeNormal) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = [UIColor grayColor];
        self.detailLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
        self.detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
        
    } else {
        UILabel *deleteLabel = [[UILabel alloc] init];
        deleteLabel.text = RZLocalizedString(@"SETTING_CELL_LOGOUT", @"设置页面退出登录一栏【退出登录】");
        deleteLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        deleteLabel.textColor = [UIColor redColor];
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:deleteLabel];
        [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
    }
}

#pragma mark - Setter
- (void)setAvatarImgUrl:(NSString *)avatarImgUrl {
    _avatarImgUrl = avatarImgUrl;
    if (_avatarImgUrl) {
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:avatarImgUrl] placeholderImage:[UIImage imageNamed:@""]];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (_title) {
        self.titleLabel.text = _title;
    }
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    if (_detail) {
        self.detailLabel.text = _detail;
    }
}

@end
