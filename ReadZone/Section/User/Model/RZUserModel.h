//
//  RZUserModel.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/31.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBase : NSObject

@property(nonatomic,copy) NSString *__type;
@property(nonatomic,copy) NSString *className;
@property(nonatomic,copy) NSString *objectId;

@end

@interface RZUserModel : NSObject

@property(nonatomic,strong) UserBase *user;         // 所有者

@property(nonatomic,copy) NSString *userName;       // 用户名称
@property(nonatomic,copy) NSString *account;        // 帐户（用于登录）
@property(nonatomic,copy) NSString *userAvatar;     // 用户头像（url）
@property(nonatomic,assign) NSUInteger gender;      // 性别（0：未设置 1：男 2：女 3：其它）
@property(nonatomic,strong) AVGeoPoint *userPoint;  // 用户地理位置

@property(nonatomic,copy) NSString *phoneModel;     // 手机型号
@property(nonatomic,assign) NSInteger screenScale;     // 手机视网膜屏幕倍率（2 或 3 倍）

@end
