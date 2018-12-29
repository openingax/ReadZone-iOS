//
//  TSUGCVideoPreviewViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/29.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSUGCVideoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TSUGCVideoPreviewViewController ()

@property(nonatomic,strong) NSString *videoPath;
@property(nonatomic,strong) NSString *coverImgPath;

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

- (instancetype)initWithVideoPath:(NSString *)videoPath coverImgPath:(NSString *)coverImgPath {
    if (self = [super init]) {
        _videoPath = videoPath;
        _coverImgPath = coverImgPath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentHeight = kScreenWidth * 16 / 9;
    _contentMarginBottom = (kScreenHeight - _contentHeight) / 2;
}

- (void)addOwnViews {
    [super addOwnViews];
    
    _playerLayer = [AVPlayerLayer layer];
    [self.view.layer addSublayer:_playerLayer];
    
    _revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_revokeBtn setImage:[UIImage tim_imageWithBundleAsset:@""] forState:UIControlStateNormal];
    [_revokeBtn setImage:[UIImage tim_imageWithBundleAsset:@""] forState:UIControlStateSelected];
    
}

- (void)layoutSubviewsFrame {
    [super layoutSubviewsFrame];
    
    
}


@end
