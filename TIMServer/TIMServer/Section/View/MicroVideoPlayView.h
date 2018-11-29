//
//  MicroVideoPlayView.h
//  MicroVideo
//
//  Created by wilderliao on 16/5/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TSIMMsg.h"

@interface MicroVideoPlayView : UIView
{
    TSIMMsg *_msg;
    NSURL   *_videoURL;
    UIImage *_coverImage;
    
    UIButton        *_playerBtn;
    
    AVPlayerItem    *_playItem;
    AVPlayer        *_player;
    AVPlayerLayer   *_playerLayer;
    BOOL            _isPlaying;
    
    CGRect          _selfFrame;
}

@property (nonatomic, strong) NSURL   *videoURL;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

- (void)setMessage:(TSIMMsg *)msg;

- (void)relayoutSubViews;

@end

@interface MicroVideoFullScreenPlayView : MicroVideoPlayView

@end
