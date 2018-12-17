//
//  TSIMMsg.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImSDK/ImSDK.h>
#import "TSIMGroupMember.h"

/**
 * 消息类型
 */
typedef NS_ENUM(NSInteger, TSIMMsgType) {
    TSIMMsgTypeUnknow,              // 未知消息类型
    TSIMMsgTypeText,                // 文本
    TSIMMsgTypeImage,               // 图片
    TSIMMsgTypeFile,                // 文件
    TSIMMsgTypeSound,               // 语音
    
    TSIMMsgTypeFace,                // 表情
    TSIMMsgTypeLocation,            // 定位
    TSIMMsgTypeVideo,               // 视频消息
    TSIMMsgTypeCustom,              // 自定义
    
    TSIMMsgTypeTimeTip,             // 时间提醒标签
    TSIMMsgTypeGroupTips,           // 群提醒
    TSIMMsgTypeGroupSystem,         // 群系统消息
    TSIMMsgTypeSNSSystem,           // 关系链消息
    TSIMMsgTypeProfileSystem,       // 资料变更消息
    
    TSIMMsgTypeInputStatus,         // 对方输入状态
    TSIMMsgTypeSaftyTip,            // 敏感词消息提醒标签
    TSIMMsgTypeRevokedTip           // 消息撤回
};

/**
 * 消息状态
 */
typedef NS_ENUM(NSInteger, TSIMMsgStatus) {
    TSIMMsgStatusInit = -1,                                     // 初始化
    TSIMMsgStatusWillSending,                                   // 即将发送
    TSIMMsgStatusSending = TIM_MSG_STATUS_SENDING,              // 消息发送中
    TSIMMsgStatusSendSucc = TIM_MSG_STATUS_SEND_SUCC,           // 消息发送成功
    TSIMMsgStatusSendFail = TIM_MSG_STATUS_SEND_FAIL,           // 消息发送失败
};

@interface TSIMMsg : NSObject
{
@protected
    TIMMessage      *_msg;
    
@protected
    TSIMMsgType     _type;
    NSInteger       _status;
    
@protected
    // 附加参数，因IMSDK底层有保护机制，从底层获取到的信息，每次都会copy一份
    // 使用此参数来优化界面更新
    NSMutableDictionary *_affixParams;
}

@property(nonatomic,readonly) TSIMMsgType type;
@property(nonatomic,readonly) TIMMessage *msg;
@property(nonatomic,readonly) NSInteger status;
@property(nonatomic,assign) BOOL isPicked;

+ (instancetype)msgWithText:(NSString *)text;
+ (instancetype)msgWithImage:(UIImage *)img isOriginal:(BOOL)original;
+ (instancetype)msgWithImages:(NSArray <UIImage*>*)images isOriginal:(BOOL)original;
+ (instancetype)msgWithDate:(NSDate *)date;
+ (instancetype)msgWithRevoked:(NSString *)sender;
+ (instancetype)msgWithFilePath:(NSURL *)filePath;
+ (instancetype)msgWithSound:(NSData *)data duration:(NSInteger)duration;
+ (instancetype)msgWithEmptySound;
+ (instancetype)msgWithVideoPath:(NSString *)videoPath;

+ (instancetype)msgWithCustom:(NSInteger)command;

+ (instancetype)msgWithMsg:(TIMMessage *)msg;

- (NSString *)msgTime;
- (NSString *)msgTip;
- (void)changeTo:(TSIMMsgStatus)status needRefresh:(BOOL)need;
- (void)remove;

// 获取发件人
- (TSIMUser *)getSender;

// 是否为我发的消息
- (BOOL)isMineMsg;
- (BOOL)isC2CMsg;
- (BOOL)isGroupMsg;
- (BOOL)isSystemMsg;
- (BOOL)isValiedType;

- (BOOL)isMultiMsg;

// 外部不调用，只限于TIMAdapter文件目录下代码调用
// affix param method

- (void)addString:(NSString *)aValue forKey:(id<NSCopying>)aKey;
- (void)addInteger:(NSInteger)aValue forKey:(id<NSCopying>)aKey;
- (void)addCGFloat:(CGFloat)aValue forKey:(id<NSCopying>)aKey;
- (void)addBOOL:(BOOL)aValue forKey:(id<NSCopying>)aKey;

- (NSString *)stringForKey:(id<NSCopying>)key;
- (NSInteger)integerForKey:(id<NSCopying>)key;
- (BOOL)boolForKey:(id<NSCopying>)key;
- (CGFloat)floatForKey:(id<NSCopying>)key;

@end
