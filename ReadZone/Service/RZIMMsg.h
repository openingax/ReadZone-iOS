//
//  RZIMMsg.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>

/**
 * 消息类型
 */
typedef NS_ENUM(NSInteger, RZIMMsgType) {
    RZIMMsgTypeUnknow,              // 未知消息类型
    RZIMMsgTypeText,                // 文本
    RZIMMsgTypeImage,               // 图片
    RZIMMsgTypeFile,                // 文件
    RZIMMsgTypeSound,               // 语音
    RZIMMsgTypeFace,                // 表情
    RZIMMsgTypeLocation,            // 定位
    RZIMMsgTypeVideo,               // 视频消息
    RZIMMsgTypeCustom,              // 自定义
    RZIMMsgTypeTimTip,              // 时间提醒标签
    RZIMMsgTypeGroupTips,           // 群提醒
    RZIMMsgTypeGroupSystem,         // 群系统消息
    RZIMMsgTypeSNSSystem,           // 关系链消息
    RZIMMsgTypeProfileSystem,       // 资料变更消息
    RZIMMsgTypeInputStatus,         // 对方输入状态
    RZIMMsgTypeSaftyTip,            // 敏感词消息提醒标签
};

/**
 * 消息状态
 */
typedef NS_ENUM(NSInteger, RZIMMsgStatus) {
    RZIMMsgStatusInit = -1,                                     // 初始化
    RZIMMsgStatusWillSending,                                   // 即将发送
    RZIMMsgStatusSending = TIM_MSG_STATUS_SENDING,              // 消息发送中
    RZIMMsgStatusSendSucc = TIM_MSG_STATUS_SEND_SUCC,           // 消息发送成功
    RZIMMsgStatusSendFail = TIM_MSG_STATUS_SEND_FAIL,           // 消息发送失败
};

@interface RZIMMsg : NSObject
{
@protected
    TIMMessage      *_msg;
    
@protected
    RZIMMsgType     _type;
    NSInteger       _status;
    
@protected
    // 附加参数，因IMSDK底层有保护机制，从底层获取到的信息，每次都会copy一份
    // 使用此参数来优化界面更新
    NSMutableDictionary *_affixParams;
}

@property(nonatomic,readonly) RZIMMsgType type;
@property(nonatomic,readonly) TIMMessage *msg;
@property(nonatomic,readonly) NSInteger status;
@property(nonatomic,assign) BOOL isPicked;

+ (instancetype)msgWithText:(NSString *)text;
+ (instancetype)msgWithImage:(UIImage *)img isOriginal:(BOOL)original;
+ (instancetype)msgWithDate:(NSDate *)date;

+ (instancetype)msgWithFilePath:(NSURL *)filePath;
+ (instancetype)msgWithSound:(NSData *)data duration:(NSInteger)duration;
+ (instancetype)msgWithVideoPath:(NSString *)videoPath;

+ (instancetype)msgWithMsg:(TIMMessage *)msg;

- (NSString *)msgTime;
- (NSString *)msgTip;
- (void)statusChangeTo:(RZIMMsgStatus)status needRefresh:(BOOL)need;
- (void)remove;

// 获取发件人
- (RZIMMsg *)getSender;

// 是否为我发的消息
- (BOOL)isMineMsg;
- (BOOL)isC2CMsg;
- (BOOL)isGroupMsg;
- (BOOL)isSystemMsg;
- (BOOL)isValiedType;

- (BOOL)isMultiMsg;

@end
