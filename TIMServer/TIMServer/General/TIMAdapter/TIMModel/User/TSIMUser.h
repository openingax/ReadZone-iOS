//
//  TSIMUser.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import "IMAShowAble.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSIMUser : NSObject <IMAShowAble>
{
@protected
    NSString *_userId;
    NSString *_icon;
    NSString *_nickName;
    NSString *_remark;
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
