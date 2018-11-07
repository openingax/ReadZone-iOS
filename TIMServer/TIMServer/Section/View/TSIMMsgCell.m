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

@interface TSIMMsgCell ()

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
    _msgLabel = [[UILabel alloc] init];
    _msgLabel.textColor = kBlackColor;
    _msgLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_msgLabel];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12);
        make.centerY.equalTo(self.contentView);
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
