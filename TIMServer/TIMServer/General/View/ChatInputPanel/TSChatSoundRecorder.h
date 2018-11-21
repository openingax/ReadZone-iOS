//
//  TSChatSoundRecorder.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonLibrary.h"

#import "TSConversation.h"
#import "TSIMMsg.h"
#import "TSChatInputAbleView.h"
#import "TSIMManager.h"

typedef void(^TSChatSoundPlayCompletion)(void);

typedef void(^TSChatSoundStartRecordCompletion)(TSIMMsg *willSendSoundMsg);
typedef void(^TSChatSoundCancelRecordCompletion)(TSIMMsg *willSendSoundMsg);
typedef void(^TSChatSoundStopRecordCompletion)(TSIMMsg *willSendSoundMsg);


@interface TSChatRecordView : UIImageView
{
@protected
    UIImageView *_imageTip;
    UILabel     *_countdownTip;
    UILabel     *_tip;
}

- (void)prepareForUse;

@end


typedef NS_ENUM(NSInteger, TSChatRecorderState) {
    TSChatRecorderStateStoped,
    TSChatRecorderStateRecording,
    TSChatRecorderStateReleaseCancel,
    TSChatRecorderStateCountdown,
    TSChatRecorderStateMaxRecord,
    TSChatRecorderStateTooShort
};

@interface TSChatSoundRecorder : NSObject
{
@protected
    // 录音相关
    TSChatRecorderState         _recordState;
    CGFloat                     _recordPeak;
    NSInteger                   _recordDuration;
    TSIMMsg                     *_recordingMsg;
    TSChatRecordView            *_recordTipView;
    
    // 用于音频退出直播时还原现场
    NSString                        *_audioSesstionCategory;                // 进入房间时的音频类别
    NSString                        *_audioSesstionMode;                    // 进入房间时的音频模式
    AVAudioSessionCategoryOptions   _audioSesstionCategoryOptions;          // 进入房间时的音频类别选项
    
@protected
    __weak id<TSChatInputAbleViewDelegate> _recorderDelegate;
}

@property (nonatomic, assign) CGFloat           recordPeak;
@property (nonatomic, assign) NSInteger         recordDuration;
@property (nonatomic, assign) TSChatRecorderState recordState;
@property (nonatomic, weak) id<TSChatInputAbleViewDelegate> recorderDelegate;

+ (void)configWith:(TSConversation *)conv;

+ (instancetype)sharedInstance;

+ (void)destory;

- (void)startRecord;
- (void)willCancelRecord;
- (void)continueRecord;
- (void)stopRecord;

@end

@interface TSChatSoundPlayer : NSObject

+ (instancetype)sharedInstance;
+ (void)destory;

- (void)playWith:(NSData *)data finish:(CommonVoidBlock)completion;
- (void)playWithUrl:(NSURL *)url finish:(CommonVoidBlock)completion;
- (void)stopPlay;

@end
