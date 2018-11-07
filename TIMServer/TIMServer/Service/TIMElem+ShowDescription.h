//
//  TIMElem+ShowDescription.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
