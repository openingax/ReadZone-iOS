//
//  RZIMUser.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface RZIMUser : NSObject
{
@protected
    NSString *_userId;          // App 对应的账号
    NSString *_icon;            // 头像
    NSString *_nickName;        // 名称
    NSString *_remark;          // 备注名
}

@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSString *icon;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,copy) NSString *remark;

@property(nonatomic,assign) BOOL isSelected;        // for 好友选择界面

- (instancetype)initWithUserId:(NSString *)userId;
- (instancetype)initWithUserInfo:(TIMUserProfile *)userProfile;

- (BOOL)isC2CType;
- (BOOL)isGroupType;
- (BOOL)isSystemType;

@end

NS_ASSUME_NONNULL_END
