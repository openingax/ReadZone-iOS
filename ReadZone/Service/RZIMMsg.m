//
//  RZIMMsg.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZIMMsg.h"

// 聊天图片缩约图最大高度
#define kChatPicThumbMaxHeight 190.f
// 聊天图片缩约图最大宽度
#define kChatPicThumbMaxWidth 66.f

@interface RZIMMsg ()

@property(nonatomic,strong) NSMutableDictionary *affixParams;
@property(nonatomic,assign) NSInteger status;

@end

@implementation RZIMMsg

- (instancetype)initWithMsg:(TIMMessage *)msg type:(RZIMMsgType)type {
    if (self = [super init]) {
        _msg = msg;
        _type = type;
        _status = RZIMMsgStatusInit;
    }
    return self;
}

+ (instancetype)msgWithText:(NSString *)text {
    TIMTextElem *elem = [[TIMTextElem alloc] init];
    elem.text = text;
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[RZIMMsg alloc] initWithMsg:msg type:RZIMMsgTypeText];
}

+ (instancetype)msgWithImage:(UIImage *)img isOriginal:(BOOL)original {
//    CGFloat scale = 1;
//    scale = MIN(kChatPicThumbMaxHeight/img.size.height, kChatPicThumbMaxWidth/img.size.width);
//
//    CGFloat picHeight = img.size.height;
//    CGFloat picWidth = img.size.width;
//    NSInteger picThumbHeight = (NSInteger)(picHeight * scale + 1);
//    NSInteger picThumbWidth = (NSInteger)(picWidth * scale + 1);
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *nsTmpDIr = NSTemporaryDirectory();
//    NSString *filePath = [NSString stringWithFormat:@"%@uploadFile%3.f", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
//    BOOL isDirectory = NO;
//    NSError *err = nil;
//
//    // 当前sdk仅支持文件路径上传图片，将图片存在本地
//    if ([fileManager fileExistsAtPath:filePath isDirectory:&isDirectory])
//    {
//        if (![fileManager removeItemAtPath:nsTmpDIr error:&err])
//        {
//            NSLog(@"Upload Image Failed: same upload filename: %@", err);
//            return nil;
//        }
//    }
//    if (![fileManager createFileAtPath:filePath contents:UIImageJPEGRepresentation(img, 1) attributes:nil])
//    {
//        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
//        return nil;
//    }
//
//    NSString *thumbPath = [NSString stringWithFormat:@"%@uploadFile%3.f_ThumbImage", nsTmpDIr, [NSDate timeIntervalSinceReferenceDate]];
//    UIImage *thumbImage = [img thumbnailWithSize:CGSizeMake(picThumbWidth, picThumbHeight)];
//    if (![fileManager createFileAtPath:thumbPath contents:UIImageJPEGRepresentation(thumbImage, 1) attributes:nil])
//    {
//        NSLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
//        return nil;
//    }
//
//    TIMImageElem *elem = [[TIMImageElem alloc] init];
//    elem.path = filePath;
//
//    return self;
    return nil;
}

+ (instancetype)msgWithDate:(NSDate *)date {
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    RZIMMsg *imMsg = [[RZIMMsg alloc] initWithMsg:msg type:RZIMMsgTypeTimTip];
    return imMsg;
}

+ (instancetype)msgWithMsg:(TIMMessage *)msg {
    if (msg.elemCount == 0) {
        return nil;
    }
    
    RZIMMsgType type = RZIMMsgTypeUnknow;
    
    TIMElem *elem = [msg getElem:0];
    Class eleCls = [elem class];
    
    if (eleCls == [TIMTextElem class]) {
        type = RZIMMsgTypeText;
    } else if (eleCls == [TIMImageElem class]) {
        type = RZIMMsgTypeImage;
    }
    
    RZIMMsg *imMsg = [[RZIMMsg alloc] initWithMsg:msg type:type];
    [imMsg statusChangeTo:(NSInteger)msg.status needRefresh:NO];
    return imMsg;
}

- (void)statusChangeTo:(RZIMMsgStatus)status needRefresh:(BOOL)need {
    
}

- (NSString *)msgTime {
    NSDate *date = [_msg timestamp];
    NSString *time = [date shortTimeTextOfDate];
    return time;
}

- (NSInteger)status {
    if (_status == RZIMMsgStatusInit || _status == RZIMMsgStatusWillSending) {
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

@end
