//
//  TSUGCVideoPreviewViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/29.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSUGCVideoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kButtonSize 70
#define kButtonMarginBottom 50

@interface TSUGCVideoPreviewViewController ()

@property(nonatomic,strong) NSString *videoPath;
@property(nonatomic,strong) UIImage *coverImg;

@property(nonatomic,strong) UIButton *revokeBtn;
@property(nonatomic,strong) UIButton *confirmBtn;

@property(nonatomic,strong) AVPlayerItem *playerItem;
@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerLayer *playerLayer;

@property(nonatomic,assign) CGFloat contentHeight;
@property(nonatomic,assign) CGFloat contentMarginBottom;

@property(nonatomic,assign) BOOL isPlaying;

@end

@implementation TSUGCVideoPreviewViewController

- (instancetype)initWithVideoPath:(NSString *)videoPath coverImg:(UIImage *)coverImg {
    if (self = [super init]) {
        _videoPath = videoPath;
        _coverImg = coverImg;
        
        _contentHeight = kScreenWidth * 16 / 9;
        _contentMarginBottom = (kScreenHeight - _contentHeight) / 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndPlay:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self configSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 完全进入到界面时，播放视频
    [self drawPlayerLayer];
    [_player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
    [_player seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - Process

- (void)applicationDidBecomeActive:(NSNotification *)noti
{
    [_player play];
}

- (void)applicationWillResignActive:(NSNotification *)noti
{
    [_player pause];
}

#pragma mark - DrawView

- (void)addOwnViews {
    [super addOwnViews];
    
    _playerLayer = [AVPlayerLayer layer];
    [self.view.layer addSublayer:_playerLayer];
    
    _revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _revokeBtn.layer.cornerRadius = kButtonSize / 2.f;
    _revokeBtn.layer.masksToBounds = YES;
    [_revokeBtn setImage:[UIImage tim_imageWithBundleAsset:@"ugc_video_revoke"] forState:UIControlStateNormal];
    [_revokeBtn setImage:[UIImage tim_imageWithBundleAsset:@"ugc_video_revoke"] forState:UIControlStateSelected];
    _revokeBtn.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.9];
    [_revokeBtn addTarget:self action:@selector(revokeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_revokeBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.layer.cornerRadius = kButtonSize / 2.f;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn setImage:[UIImage tim_imageWithBundleAsset:@"ugc_video_confirm"] forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage tim_imageWithBundleAsset:@"ugc_video_confirm"] forState:UIControlStateSelected];
    _confirmBtn.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.9];
    [_confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmBtn];
}

- (void)layoutSubviewsFrame {
    [super layoutSubviewsFrame];
    
    _playerLayer.frame = CGRectMake(0, _contentMarginBottom, kScreenWidth, _contentHeight);
    
    [_revokeBtn setSize:CGSizeMake(kButtonSize, kButtonSize)];
    _revokeBtn.center = CGPointMake(kScreenWidth / 4.f, kScreenHeight - _contentMarginBottom - kButtonSize / 2.f - kButtonMarginBottom);
    
    [_confirmBtn setSize:CGSizeMake(kButtonSize, kButtonSize)];
    _confirmBtn.center = CGPointMake(3 * kScreenWidth / 4.f, kScreenHeight - _contentMarginBottom - kButtonSize / 2.f - kButtonMarginBottom);
}

- (void)drawPlayerLayer
{
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_videoPath]];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    [_playerLayer setPlayer:_player];
}

#pragma mark - Config

- (void)configSubviews
{
    _playerLayer.contents = (__bridge id _Nullable)(_coverImg.CGImage);
}

- (void)onEndPlay:(NSNotification *)notification
{
    AVPlayerItem *item = (AVPlayerItem *)notification.object;
    if (_playerItem == item) {
        [_player seekToTime:CMTimeMake(0, 1)];
    }
    
    __weak typeof(self) ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws.player play];
    });
}

#pragma mark - Action

- (void)revokeAction
{
    if ([[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil]) {
        DebugLog(@"\nPreview UGCVideo delete succ!\n");
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)confirmAction
{
    [self.delegate previewVideoPath:_videoPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
