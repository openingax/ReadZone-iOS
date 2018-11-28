//
//  TSIMMsg.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMMsg.h"
#import "NSDate+Common.h"
#import "TSConversation.h"
#import "TIMElem+ShowDescription.h"
#import "TIMServerHelper.h"
#import "NSMutableDictionary+Json.h"
#import "TSIMAdapter.h"

// 聊天图片缩约图最大高度
#define kChatPicThumbMaxHeight 190.f
// 聊天图片缩约图最大宽度
#define kChatPicThumbMaxWidth 66.f

@interface TSIMMsg ()

@property(nonatomic,strong) NSMutableDictionary *affixParams;
@property(nonatomic,assign) NSInteger status;

@end

@implementation TSIMMsg

- (instancetype)initWithMsg:(TIMMessage *)msg type:(TSIMMsgType)type {
    if (self = [super init]) {
        _msg = msg;
        _type = type;
        _status = TSIMMsgStatusInit;
    }
    return self;
}

+ (instancetype)msgWithText:(NSString *)text {
    TIMTextElem *elem = [[TIMTextElem alloc] init];
    elem.text = text;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeText];
}

+ (instancetype)msgWithImage:(UIImage *)img isOriginal:(BOOL)original {
    CGFloat scale = 1;
    scale = MIN(kChatPicThumbMaxHeight/img.size.height, kChatPicThumbMaxWidth/img.size.width);
    
    CGFloat picHeight = img.size.height;
    CGFloat picWidth = img.size.width;
    NSInteger picThumbHeight = (NSInteger)(picHeight * scale + 1);
    NSInteger picThumbWidth = (NSInteger)(picWidth * scale + 1);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *nsTmpDIr = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    BOOL isDirectory = NO;
    NSError *err = nil;
    
    // 当前sdk仅支持文件路径上传图片，将图片存在本地
    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
    {
        if (![fileManager removeItemAtPath:nsTmpDIr error:&err])
        {
            NSLog(@"Upload Image Failed: same upload filename: %@", err);
            return nil;
        }
    }
    if (![fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(img, 1) attributes:nil])
    {
        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    NSString *thumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f_ThumbImage", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
    UIImage *thumbImage = [img thumbnailWithSize:CGSizeMake(picThumbWidth, picThumbHeight)];
    if (![fileManager createFileAtPath:thumbPath contents:UIImageJPEGRepresentation(thumbImage, 1) attributes:nil])
    {
        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    TIMImageElem *elem = [[TIMImageElem alloc] init];
    elem.path = filePath;
    
    if (original)
    {
        elem.level = TIM_IMAGE_COMPRESS_ORIGIN;
    }
    else
    {
        elem.level = TIM_IMAGE_COMPRESS_HIGH;
    }
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    TSIMMsg *imamsg = [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeImage];
    
    [imamsg addInteger:picThumbHeight forKey:kIMAMSG_Image_ThumbHeight];
    [imamsg addInteger:picThumbWidth forKey:kIMAMSG_Image_ThumbWidth];
    [imamsg addString:filePath forKey:kIMAMSG_Image_OrignalPath];
    [imamsg addString:thumbPath forKey:kIMAMSG_Image_ThumbPath];
    
    return imamsg;
}

+ (instancetype)msgWithDate:(NSDate *)date {
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    TSIMMsg *imMsg = [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeTimeTip];
    return imMsg;
}

+ (instancetype)msgWithMsg:(TIMMessage *)msg {
    if (msg.elemCount == 0) {
        return nil;
    }
    
    TSIMMsgType type = TSIMMsgTypeUnknow;
    
    TIMElem *elem = [msg getElem:0];
    Class eleCls = [elem class];
    
    if (eleCls == [TIMTextElem class]) {
        type = TSIMMsgTypeText;
    } else if (eleCls == [TIMImageElem class]) {
        type = TSIMMsgTypeImage;
    }
    
    TSIMMsg *imMsg = [[TSIMMsg alloc] initWithMsg:msg type:type];
    [imMsg changeTo:(NSInteger)msg.status needRefresh:NO];
    return imMsg;
}

+ (instancetype)msgWithCustom:(NSInteger)command {
    return [TSIMMsg msgWithCustom:command param:nil];
}

+ (instancetype)msgWithCustom:(NSInteger)command param:(NSString *)param
{
    //    CustomElemCmd *cmd = [[CustomElemCmd alloc] initWith:command param:param];
    //
    //    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    //    elem.data = [cmd packToSendData];
    //
    //    TIMMessage *customMsg = [[TIMMessage alloc] init];
    //    [customMsg addElem:elem];
    //
    //    return [[IMAMsg alloc] initWith:customMsg type:command];
    return nil;
}

+ (instancetype)msgWithSound:(NSData *)data duration:(NSInteger)duration {
#warning 要完善
    return nil;
}

+ (instancetype)msgWithEmptySound {
#warning 要完善
    return nil;
}

- (void)changeTo:(TSIMMsgStatus)status needRefresh:(BOOL)need {
    if (_status != status) {
        if (need) {
            self.status = status;
        } else {
            _status = status;
        }
    }
}

- (NSString *)msgTime {
    NSDate *date = [_msg timestamp];
    NSString *time = [date timeTextOfDate];
    return time;
}

- (NSString *)msgTip {
    TIMConversation *conv = [_msg getConversation];
    TIMConversationType type = [conv getType];
    TIMElem *elem = (TIMElem *)[_msg getElem:0];
    if (elem) {
        if (type == TIM_C2C) {
            
            return [elem showDescriptionOf:self];
            
        } else if (type == TIM_GROUP) {
            return TIMLocalizedString(@"GROUP_MSG", @"群聊消息");
        } else if (type == TIM_SYSTEM) {
            return TIMLocalizedString(@"SYSTEM_MSG", @"系统消息");
        } else {
            return @"";
        }
    } else {
        return @"";
    }
}

- (TSIMUser *)getSender {
    return [[TSIMUser alloc] initWithUserId:[_msg sender]];
}

- (NSInteger)status {
    if (_status == TSIMMsgStatusInit || _status == TSIMMsgStatusWillSending) {
        return _status;
    } else {
        return [_msg status];
    }
}

- (BOOL)isMineMsg {
    return [_msg isSelf];
}

- (BOOL)isC2CMsg {
    return [[self.msg getConversation] getType] == TIM_C2C;
}

- (BOOL)isGroupMsg {
    return [[self.msg getConversation] getType] == TIM_GROUP;
}

- (BOOL)isSystemMsg {
    return [[self.msg getConversation] getType] == TIM_SYSTEM;
}

- (NSMutableDictionary *)affixParams {
    if (!_affixParams) {
        _affixParams = [NSMutableDictionary dictionary];
    }
    return _affixParams;
}


- (BOOL)isValiedType {
    return self.type != TSIMMsgTypeTimeTip && self.type != TSIMMsgTypeSaftyTip;
}

- (BOOL)isMultiMsg
{
    return _type == TSIMMsgTypeFace || _msg.elemCount > 1;
}

// 外部不调用，只限于TIMAdapter文件目录下代码调用
// affix param method

- (void)addString:(NSString *)aValue forKey:(id<NSCopying>)aKey {
    [self.affixParams addString:aValue forKey:aKey];
}

- (void)addInteger:(NSInteger)aValue forKey:(id<NSCopying>)aKey {
    [self.affixParams addInteger:aValue forKey:aKey];
}

- (void)addCGFloat:(CGFloat)aValue forKey:(id<NSCopying>)aKey {
    [self.affixParams addCGFloat:aValue forKey:aKey];
}

- (void)addBOOL:(BOOL)aValue forKey:(id<NSCopying>)aKey {
    [self.affixParams addBOOL:aValue forKey:aKey];
}

- (NSString *)stringForKey:(id<NSCopying>)key
{
    return [self.affixParams stringForKey:key];
}
- (NSInteger)integerForKey:(id<NSCopying>)key
{
    return [self.affixParams integerForKey:key];
}
- (BOOL)boolForKey:(id<NSCopying>)key
{
    return [self.affixParams boolForKey:key];
}
- (CGFloat)floatForKey:(id<NSCopying>)key
{
    return [self.affixParams floatForKey:key];
}

@end
