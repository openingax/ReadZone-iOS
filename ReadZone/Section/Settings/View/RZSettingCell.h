//
//  RZSettingCell.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/13.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RZSettingCellType) {
    RZSettingCellTypeNormal = 0,    // 常规
    RZSettingCellTypeAvatar,        // 头像
    RZSettingCellTypeDelete         // 退出登录
};

@interface RZSettingCell : UITableViewCell

@property(nonatomic,strong) UIImageView *avatarImgView;
@property(nonatomic,copy) NSString *avatarImgUrl;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *detail;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(RZSettingCellType)type;

@end
