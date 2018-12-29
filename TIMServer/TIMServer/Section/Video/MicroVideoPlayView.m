//
//  MicroVideoPlayView.m
//  MicroVideo
//
//  Created by wilderliao on 16/5/23.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "MicroVideoPlayView.h"
#import <AVKit/AVKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TSDebugMarco.h"
#import "TSIMAPlatform.h"
#import "TIMServerHelper.h"

@implementation MicroVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _selfFrame = frame;
        self.backgroundColor = [UIColor blackColor];
        [self addSubviews];
        [self configSubviews];
        [self relayoutSubViews];
        
        [self addObserver];
    }
    return self;
}

- (void)setMessage:(TSIMMsg *)msg
{
    _msg = msg;
    [self setCoverImage];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndPlay:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScaling)];
    [self addGestureRecognizer:tap];
}

- (void)addSubviews
{
    _playerLayer = [AVPlayerLayer layer];
    [self.layer addSublayer:_playerLayer];
    
     _playerBtn = [[UIButton alloc] init];
    [self addSubview:_playerBtn];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    [self addSubview:_timeLabel];
}

- (void)configSubviews
{
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerLayer.masksToBounds = YES;
    
    [_playerBtn setBackgroundColor:[UIColor clearColor]];
    [_playerBtn setBackgroundImage:[UIImage tim_imageWithBundleAsset:@"record_playbutton"] forState:UIControlStateNormal];
    [_playerBtn setBackgroundImage:[UIImage tim_imageWithBundleAsset:@"record_errorbutton"] forState:UIControlStateDisabled];
    [_playerBtn addTarget:self action:@selector(onPlay:) forControlEvents:UIControlEventTouchUpInside];
}

//设置小视频消息封面图片
- (void)setCoverImage
{
//    if (![[[_msg.msg getElem:0] class] isKindOfClass:[TIMUGCElem class]]) {
//        return;
//    }
    TIMUGCElem *elem = (TIMUGCElem *)[_msg.msg getElem:0];

    //将封面截图保存到 “Caches/视频id” 路径

    NSString *hostCachesPath = [self getHostCachesPath];
    if (!hostCachesPath)
    {
        return;
    }

    NSString *imagePath = [NSString stringWithFormat:@"%@/snapshot_%@", hostCachesPath, elem.videoId];

    NSFileManager *fileMgr = [NSFileManager defaultManager];

    if (elem.coverPath && [fileMgr fileExistsAtPath:elem.coverPath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:elem.coverPath];
        _coverImage = image;
        _playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
    }
    else if ([fileMgr fileExistsAtPath:imagePath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        _coverImage = image;
        _playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
    }
    else
    {
        __weak MicroVideoPlayView *ws = self;
//        if (elem.snapshot.uuid && elem.snapshot.uuid.length > 0)
        if (elem.videoId && elem.videoId.length > 0)
        {
            [elem.cover getImage:imagePath succ:^{
                UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                ws.coverImage = image;
                ws.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
            } fail:^(int code, NSString *msg) {
                UIImage *image = [UIImage imageNamed:@"default_video"];
                ws.coverImage = image;
                ws.playerLayer.contents = (__bridge id _Nullable)(image.CGImage);
//                [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err)];
                
            }];
        }
    }
    
    _timeLabel.text = [self videoTimeStrWithDuration:elem.video.duration/1000];
}

- (NSString *)videoTimeStrWithDuration:(int)duration {
    int minute = duration / 60;
    NSString *minutes = nil;
    if (minute >= 10) {
        minutes = [NSString stringWithFormat:@"%d", minute];
    } else {
        minutes = [NSString stringWithFormat:@"0%d", minute];
    }
    
    int second = duration % 60;
    NSString *seconds = nil;
    if (second >= 10) {
        seconds = [NSString stringWithFormat:@"%d", second];
    } else {
        seconds = [NSString stringWithFormat:@"0%d", second];
    }
    
    return [NSString stringWithFormat:@"%@:%@", minutes, seconds];
}

- (void)downloadVideo:(TIMSucc)succ fail:(TIMFail)fail
{
    TIMUGCElem *elem = (TIMUGCElem *)[_msg.msg getElem:0];

//    if (!(elem.video.uuid && elem.video.uuid.length > 0))
    if (!(elem.videoId && elem.videoId.length > 0))
    {
        DebugLog(@"小视频ID为空");
        if (fail)
        {
            fail(-1, @"小视频ID为空");
        }
        return;
    }
    
    NSString *hostCachesPath = [self getHostCachesPath];
    if (!hostCachesPath)
    {
        DebugLog(@"获取本地路径出错");
        if (fail)
        {
            fail(-2, @"获取本地路径出错");
        }
        return;
    }
    
    /*
     加载小视频文件的缓存策略：
     
     1、第一步先判断 /tmp 目录有没有视频文件，有的话直接播放；（如果视频为本人发送，且没清空缓存目录时，文件会存在）
     2、/tmp 没有视频文件的话，就去检查当前登录用户的文件夹有没有视频文件，有的话直接播放；（如果用户通过第3步下载过视频在用户文件夹，则文件会存在）
     3、用户文件夹如果没有视频，就根据 videoPath 去下载，下载完成后播放。此时下载好的视频会保存在用户文件夹里，下次再播放时能直接播放。
     */
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *tmpVideoPath = elem.videoPath;
    
    // 1、先检查 /tmp 目录有没有视频文件
    if ([fileMgr fileExistsAtPath:tmpVideoPath isDirectory:nil]) {
        _videoURL = [NSURL fileURLWithPath:tmpVideoPath];
        [self initPlayer];
        if (succ) succ();
        return;
    }

    // 2、去检查用户目录有没有视频文件
    NSString *videoPath = [NSString stringWithFormat:@"%@/video_%@.%@", hostCachesPath, elem.videoId, elem.video.type];

    if ([fileMgr fileExistsAtPath:videoPath isDirectory:nil])
    {
        _videoURL = [NSURL fileURLWithPath:videoPath];
        [self initPlayer];
        if (succ)
        {
            succ();
        }
    }
    else
    {
        __weak MicroVideoPlayView *ws = self;
        [elem.video getVideo:videoPath succ:^{
            ws.videoURL = [NSURL fileURLWithPath:videoPath];
            [ws initPlayer];
            if (succ)
            {
                succ();
            }
        } fail:^(int code, NSString *err) {
//            [[HUDHelper sharedInstance] syncStopLoadingMessage:IMALocalizedError(code, err)];
            if (fail)
            {
                fail(code,err);
            }
        }];
    }
}

- (NSString *)getHostCachesPath
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,  NSUserDomainMask,YES);
    NSString *cachesPath =[cachesPaths objectAtIndex:0];
    NSString *hostCachesPath = [NSString stringWithFormat:@"%@/%@",cachesPath, [TSIMAPlatform sharedInstance].host.profile.identifier];

    if (![fileMgr fileExistsAtPath:hostCachesPath])
    {
        NSError *err = nil;

        if (![fileMgr createDirectoryAtPath:hostCachesPath withIntermediateDirectories:YES attributes:nil error:&err])
        {
            DebugLog(@"Create HostCachesPath fail: %@", err);
            return nil;
        }
    }
    return hostCachesPath;
}

- (void)initPlayer
{
    _playItem = [AVPlayerItem playerItemWithURL:_videoURL];
    _player   = [AVPlayer playerWithPlayerItem:_playItem];
    
    [_playerLayer setPlayer:_player];
}

- (void)onPlay:(UIButton *)button
{
    if ([self isKindOfClass:[MicroVideoFullScreenPlayView class]]) {
        [self downloadVideo:^{
            
            [_player play];
            button.hidden = YES;
            
        } fail:nil];
    } else {
        [self onScaling];
    }
}

-(void)onEndPlay:(NSNotification *)notification
{
    AVPlayerItem *item = (AVPlayerItem *)notification.object;
    if (_playItem == item)
    {
        _playerBtn.hidden = NO;
        [_player seekToTime:CMTimeMake(0, 1)];
    }
}

- (void)onScaling
{
    CGRect screen = [UIScreen mainScreen].bounds;
    MicroVideoFullScreenPlayView *fullScreen = [[MicroVideoFullScreenPlayView alloc] initWithFrame:screen];
    [fullScreen setMessage:_msg];
    
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:fullScreen];
}

- (void)relayoutSubViews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _playerLayer.frame = self.bounds;
    
    _playerBtn.frame = CGRectMake(selfWidth/2 - 23, selfHeight/2 - 23, 46, 46);
    
    _timeLabel.frame = CGRectMake(selfWidth/2 + 20, selfHeight - 20, 50, 20);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _msg = nil;
    _videoURL = nil;
    _coverImage = nil;
    _playerBtn = nil;
    _playItem = nil;
    _player = nil;
    _playerLayer = nil;
}

@end

/////////////////////////////////////////////////////
@implementation MicroVideoFullScreenPlayView

- (void)onScaling
{
    [self removeFromSuperview];
}

- (void)relayoutSubViews
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat width = screen.size.width;
    CGFloat height = screen.size.width * 16 / 9;
    
    CGFloat marginTop = (screen.size.height - height) / 2;
    
    _playerLayer.frame = CGRectMake(0, marginTop, width, screen.size.width * 16 / 9);
    
    _playerBtn.frame = CGRectMake(selfWidth/2 - 30, selfHeight/2 - 30, 60, 60);
}

@end
