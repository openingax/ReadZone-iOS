//
//  TIMElem+ShowDescription.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import <UIKit/UIKit.h>
#import <IMUGCExt/IMUGCExt.h>

@class TSIMMsg;

@interface TIMElem (ShowDescription)

// 显示描述
- (NSString *)showDescriptionOf:(TSIMMsg *)msg;

// 是否是系统表情
- (BOOL)isSystemFace;

@end

@interface TIMTextElem (ShowDescription)

@end

typedef void (^AsyncGetThumbImageBlock)(NSString *path, UIImage *image, BOOL succ, BOOL isAsync);

@interface TIMImageElem (ShowDescription)

- (void)asyncThumbImage:(AsyncGetThumbImageBlock)block inMsg:(TSIMMsg *)msg;

// 获取消息的缓存图片
- (UIImage *)getThumbImageInMsg:(TSIMMsg *)msg;

@end

@interface TIMFileElem (ShowDescription)

@end

@interface TIMSoundElem (ShowDescription)

@end

@interface TIMFaceElem (ShowDescription)

// 是否是系统表情
- (BOOL)isSystemFace;

@end

@interface TIMLocationElem (ShowDescription)

@end

@interface TIMGroupTipsElem (ShowDescription)

@property (nonatomic, strong) NSString *groupType;
// 群提醒消息
@property (nonatomic, strong) NSString *groupTip;

// 提示的文本
- (NSString *)tipText;

@end

@interface TIMUGCElem (ShowDescription)

@end

@interface TIMCustomElem (ShowDescription)

// 目前聊天界面用的时间戮是用TIMCustomElem
// 将要显示的时间转成Data
- (void)setFollowTime:(NSDate *)date;

// 显示的时间戮
- (NSString *)timeTip;

- (NSString *)revokedTip;

@end


@interface TIMGroupSystemElem (ShowDescription)



@end
