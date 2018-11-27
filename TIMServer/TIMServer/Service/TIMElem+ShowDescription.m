//
//  TIMElem+ShowDescription.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TIMElem+ShowDescription.h"
#import "NSDate+Common.h"

@implementation TIMElem (ShowDescription)

- (NSString *)showDescriptionOf:(TSIMMsg *)msg {
    return [self description];
}

- (BOOL)isSystemFace {
    return NO;
}

@end


@implementation TIMTextElem (ShowDescription)

- (NSString *)showDescriptionOf:(TSIMMsg *)msg {
    return [self text];
}

@end


@implementation TIMImageElem (ShowDescription)


@end


@implementation TIMFileElem (ShowDescription)



@end

@implementation TIMSoundElem (ShowDescription)

@end


@implementation TIMFaceElem (ShowDescription)


@end


@implementation TIMLocationElem (ShowDescription)


@end


@implementation TIMGroupTipsElem (ShowDescription)

@end


@implementation TIMUGCElem (ShowDescription)

@end


@implementation TIMCustomElem (ShowDescription)

// 目前聊天界面用的时间戮是用TIMCustomElem
// 将要显示的时间转成Data
- (void)setFollowTime:(NSDate *)date
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:date];
    self.data = data;
}

- (NSDate *)getFollowTime
{
    NSDate *date = [NSKeyedUnarchiver unarchiveObjectWithData:self.data];
    return date;
}

// 显示的时间戮
- (NSString *)timeTip {
    NSDate *date = [self getFollowTime];
    return [date timeTextOfDate];
}

- (NSString *)revokedTip {
    return @"消息已被撤回";
}

@end
