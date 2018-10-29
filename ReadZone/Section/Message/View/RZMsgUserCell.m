//
//  RZMsgUserCell.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZMsgUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RZMsgUserCell ()

@property(nonatomic,strong) UIImageView *iconImgView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *msgLabel;

@end

@implementation RZMsgUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawView];
    }
    return self;
}

- (void)drawView {
    _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_default_avatar"]];
    _iconImgView.layer.cornerRadius = 5;
    [self.contentView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(18);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).with.offset(6);
        make.top.equalTo(self.iconImgView.mas_top).with.offset(2);
    }];
    
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.textColor = [UIColor grayColor];
    _msgLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    [self.contentView addSubview:_msgLabel];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.iconImgView.mas_bottom).with.offset(-2);
    }];
}

- (void)setIconUrl:(NSString *)iconUrl {
    _iconUrl = iconUrl;
    if (![NSString isEmptyString:_iconUrl]) {
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"user_default_avatar"]];
    }
    
}

- (void)setName:(NSString *)name {
    _name = name;
    if (![NSString isEmptyString:_name]) {
        _nameLabel.text = _name;
    }
}

- (void)setMsg:(NSString *)msg {
    _msg = msg;
    if (![NSString isEmptyString:msg]) {
        _msgLabel.text = _msg;
    }
}

@end
