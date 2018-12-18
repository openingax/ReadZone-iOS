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
#import <AVFoundation/AVFoundation.h>
#import "PathUtility.h"
#import <IMMessageExt/IMMessageExt.h>
#import "CustomElemCmd.h"

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

+ (TIMImageElem *)imageElemWithImage:(UIImage *)img isOriginal:(BOOL)original {
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
    
    return elem;
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

+ (instancetype)msgWithImages:(NSArray <UIImage*>*)images isOriginal:(BOOL)original {
    TIMMessage *msg = [[TIMMessage alloc] init];
    for (UIImage *img in images) {
        [msg addElem:[TSIMMsg imageElemWithImage:img isOriginal:original]];
    }
    
    TSIMMsg *imamsg = [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeImage];
    
    //    [imamsg addInteger:picThumbHeight forKey:kIMAMSG_Image_ThumbHeight];
    //    [imamsg addInteger:picThumbWidth forKey:kIMAMSG_Image_ThumbWidth];
    //    [imamsg addString:filePath forKey:kIMAMSG_Image_OrignalPath];
    //    [imamsg addString:thumbPath forKey:kIMAMSG_Image_ThumbPath];
    
    return imamsg;
}

+ (instancetype)msgWithRevoked:(NSString *)sender
{
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    NSDictionary *dataDic = @{@"sender":sender, @"REVOKED":@1};
    NSError *error = nil;
    elem.data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&error];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    TSIMMsg *imamsg = [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeRevokedTip];
    return imamsg;
}

+ (instancetype)msgWithDate:(NSDate *)date {
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    [elem setFollowTime:date];
    
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
    } else if (eleCls == [TIMUGCElem class]) {
        type = TSIMMsgTypeVideo;
    } else if (eleCls == [TIMSoundElem class]) {
        type = TSIMMsgTypeSound;
    } else if (eleCls == [TIMCustomElem class]) {
        type = TSIMMsgTypeCustom;
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
    CustomElemCmd *cmd = [[CustomElemCmd alloc] initWith:command param:param];
    
    TIMCustomElem *elem = [[TIMCustomElem alloc] init];
    elem.data = [cmd packToSendData];
    
    TIMMessage *customMsg = [[TIMMessage alloc] init];
    [customMsg addElem:elem];
    
    return [[TSIMMsg alloc] initWithMsg:customMsg type:command];
}

+ (instancetype)msgWithSound:(NSData *)data duration:(NSInteger)duration {
    if (!data) {
        return nil;
    }
    
    NSString *cache = [PathUtility getCachePath];
    NSString *loginId = [[TIMManager sharedInstance] getLoginUser];
    
    NSDate *date = [[NSDate alloc] init];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%llu", (unsigned long long)time];
    NSString *soundSaveDir = [NSString stringWithFormat:@"%@/%@/Audio", cache, loginId];
    
    if (![PathUtility isExistFile:soundSaveDir]) {
        BOOL isCreateDir = [[NSFileManager defaultManager] createDirectoryAtPath:soundSaveDir withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir)
        {
            return nil;
        }
    }
    
    NSString *soundSavePath = [NSString stringWithFormat:@"%@/%@",soundSaveDir,timeStr];
    if (![PathUtility isExistFile:soundSavePath])
    {
        BOOL isCreate = [[NSFileManager defaultManager] createFileAtPath:soundSavePath contents:nil attributes:nil];
        if (!isCreate)
        {
            return nil;
        }
    }
    BOOL isWrite = [data writeToFile:soundSavePath atomically:YES];
    if (!isWrite)
    {
        return nil;
    }
    
    TIMSoundElem *elem = [[TIMSoundElem alloc] init];
    elem.path = soundSavePath;
    elem.second = (int)duration;
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeSound];
}

+ (instancetype)msgWithEmptySound {
    
    TIMSoundElem *elem = [[TIMSoundElem alloc] init];
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    
    return [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeSound];
}

+ (instancetype)msgWithVideoPath:(NSString *)videoPath {
    
    if (!videoPath) {
        return nil;
    }
    
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(240, 320));
    
    UIGraphicsBeginImageContext(CGSizeMake(240, 320));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, 240, 320)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    NSData *snapshotData = UIImageJPEGRepresentation(scaledImage, 0.75);
    
    //保存截图到临时目录
    NSString *tempDir = NSTemporaryDirectory();
    NSString *snapshotPath = [NSString stringWithFormat:@"%@%3.f", tempDir, [NSDate timeIntervalSinceReferenceDate]];
    
    NSError *err;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr createFileAtPath:snapshotPath contents:snapshotData attributes:nil])
    {
        DebugLog(@"Upload Image Failed: fail to create uploadfile: %@", err);
        return nil;
    }
    
    //创建 TIMUGCElem
    TIMUGCVideo* video = [[TIMUGCVideo alloc] init];
    video.type = @"mp4";
    video.duration = (int)urlAsset.duration.value/urlAsset.duration.timescale;
    
    TIMUGCCover *corver = [[TIMUGCCover alloc] init];
    corver.type = @"jpg";
    corver.width = scaledImage.size.width;
    corver.height = scaledImage.size.height;
    
    TIMUGCElem* elem = [[TIMUGCElem alloc] init];
    elem.video = video;
    elem.videoPath = videoPath;
    elem.coverPath = snapshotPath;
    elem.cover = corver;
    
    TIMMessage* msg = [[TIMMessage alloc] init];
    [msg addElem:elem];
    TSIMMsg *videoMsg = [[TSIMMsg alloc] initWithMsg:msg type:TSIMMsgTypeVideo];
    
    return videoMsg;
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

- (void)remove
{
    if (self.type == TSIMMsgTypeTimeTip || self.type == TSIMMsgTypeSaftyTip)
    {
        // 属于自定义的类型，不在IMSDK数据库里面，不能调remove接口
        return;
    }
    
    BOOL succ = [_msg remove];
    DebugLog(@"删除成功：%d", succ);
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
    if ([[_msg getConversation] getType] == TIM_C2C) {
        TSIMUser *user = [[TSIMUser alloc] initWithUserId:[_msg sender]];
        return user;
    } else if ([[_msg getConversation] getType] == TIM_GROUP) {
        TSIMGroupMember *member = [[TSIMGroupMember alloc] initWithMemberInfo:[_msg getSenderGroupMemberProfile]];
        if (member) {
            TSIMUser *user = [[TSIMUser alloc] initWithUserInfo:[_msg getSenderProfile]];
            [member setIcon:user.icon];
            
            if (member.memberInfo.nameCard.length <= 0) {
                [member setNickName:[user showTitle]];
            }
        }
        
        return member;
    }
    
    return nil;
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
#warning 这里处理哪些信息是合法有效的，否则会造成下拉刷新出错
    /* 在原 Demo 的基础上，加多一个判断 self.type > 0，即不会出现那种 self.status 为 -1 的初始化状态信息 */
    return self.type != TSIMMsgTypeTimeTip && self.status > 0 && self.type != TSIMMsgTypeSaftyTip;
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
