//
//  TSIMMsgCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsgCell.h"
#import "UIView+CustomAutoLayout.h"
#import "TSColorMarco.h"
#import "UIView+Layout.h"
#import <Masonry/Masonry.h>
#import "TSConstMarco.h"
#import "TIMServerHelper.h"
#import <YMCommon/YMCFont.h>

// [UIImage imageWithBundleAsset:@"chat_bubble_in"];

@interface TSIMMsgCell ()

@property(nonatomic,strong) UIImageView *iconImgView;
@property(nonatomic,strong) UIImageView *chatImgView;
@property(nonatomic,strong) UILabel *msgLabel;

@end

@implementation TSIMMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGB(247, 247, 247);
        [self drawView];
    }
    return self;
}

- (void)drawView {
    
    _iconImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithBundleAsset:@""]];
    _iconImgView.backgroundColor = RGB(54, 106, 133);
    [self.contentView addSubview:_iconImgView];
    [_iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.top.equalTo(self.contentView).with.offset(12);
        make.bottom.equalTo(self.contentView).with.offset(-12);
    }];
    
    _chatImgView = [[UIImageView alloc] initWithImage:[UIImage imageWithBundleAsset:@""]];
    _chatImgView.backgroundColor = kClearColor;
    [self.contentView addSubview:self.chatImgView];
    [_chatImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).with.offset(6);
        make.top.equalTo(self.iconImgView.mas_top);
        make.right.equalTo(self.contentView).with.offset(-56);
        make.height.mas_equalTo(44);
    }];
    
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.textColor = kBlackColor;
    _msgLabel.numberOfLines = 0;
    _msgLabel.font = [YMCFont fontOfType:YMCFontTypeOutside size:14];
    [_chatImgView addSubview:_msgLabel];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatImgView).with.offset(20);
        make.top.equalTo(self.chatImgView).with.offset(12);
        make.right.equalTo(self.chatImgView).with.offset(-20);
    }];
}

- (void)layoutSubviews {
    
}

- (void)setMsg:(NSString *)msg {
    _msg = msg;
    if (_msg) {
        self.msgLabel.text = _msg;
    }
}

@end
