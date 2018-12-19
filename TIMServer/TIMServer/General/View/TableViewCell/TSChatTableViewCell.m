//
//  TSChatTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatTableViewCell.h"
#import "UIView+Glow.h"
#import "ChatSoundRecorder.h"
#import "PathUtility.h"
#import "TIMServerHelper.h"
#import "ChatImageBrowserView.h"
#import "UIView+RelativeCoordinate.h"

@implementation TSChatTextTableViewCell

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _chatText = [[UILabel alloc] init];
    _chatText.textAlignment = NSTextAlignmentLeft;
    _chatText.numberOfLines = 0;
    _chatText.lineBreakMode = NSLineBreakByWordWrapping;
    _chatText.userInteractionEnabled = YES;
    return _chatText;
}

- (void)configContent
{
    [super configContent];
    
    _chatText.font = [_msg textFont];
    _chatText.textColor = [_msg textColor];
    
    TIMTextElem *elem = (TIMTextElem *)[_msg.msg getElem:0];
    _chatText.text = [elem text];
}

@end

@implementation TSChatImageTableViewCell

// 只创建，外部统一添加
- (UIView *)addElemContent
{
    _chatImage = [[UIImageView alloc] init];
    _chatImage.backgroundColor = [UIColor flatGrayColor];
    _chatImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_chatImage addGestureRecognizer:tap];
    
    return _chatImage;
}

- (void)onTapImage:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded){
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        
        UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
        CGRect rect = [_chatImage relativePositionTo:keyWindow];
        ChatImageBrowserView *view = [[ChatImageBrowserView alloc] initWithPicModel:_msg thumbnail:_chatImage.image fromRect:rect];
        [keyWindow addSubview:view];
    }
}

- (void)configContent
{
    [super configContent];
    
    TIMImageElem *elem = (TIMImageElem *)[_msg.msg getElem:0];
    
    __weak UIImageView *wci = _chatImage;
    [elem asyncThumbImage:^(NSString *path, UIImage *image, BOOL succ, BOOL isAsync) {
        wci.image = image ? image : [UIImage tim_imageWithBundleAsset:@"default_image"];
    } inMsg:_msg];
}

@end

@implementation TSChatSoundTableViewCell

- (void)dealloc {
    
}

- (UIView *)addElemContent {
    _soundButton = [[ImageTitleButton alloc] init];
    _soundButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_soundButton addTarget:self action:@selector(onPlaySound) forControlEvents:UIControlEventTouchUpInside];
    _soundButton.userInteractionEnabled = YES;
    return _soundButton;
}

- (void)configSendingTips {
    [super configSendingTips];
    if (_msg.status == TSIMMsgStatusWillSending) {
        _elemContentRef.hidden = YES;
        [_contentBack startGlowing];
    } else {
        _elemContentRef.hidden = NO;
        [_contentBack stopGlowing];
    }
}

- (void)configContent {
    [super configContent];
    
    [self stopPlaySound];
    
    // 停止上一次的播放
    [_soundButton.imageView stopAnimating];
    
    BOOL isMine = [_msg isMineMsg];
//    _soundButton.style = isMine ? ETitleLeftImageRight : EImageLeftTitleRight;
    _soundButton.style = isMine ? EImageLeftTitleRight : EImageLeftTitleRight;
    [_soundButton setImage:isMine ? [UIImage tim_imageWithBundleAsset:@"other_voice3"] : [UIImage tim_imageWithBundleAsset:@"other_voice3"] forState:UIControlStateNormal];
    [_soundButton setTitleColor:[_msg textColor] forState:UIControlStateNormal];
    
    TIMSoundElem *elem = (TIMSoundElem *)[_msg.msg getElem:0];
    [_soundButton setTitle:[NSString stringWithFormat:@"%d''", elem.second] forState:UIControlStateNormal];
}

- (void)startPlaySoundAnimating {
    BOOL isMine = [_msg isMineMsg];
    if (isMine)
    {
        _soundButton.imageView.animationImages = @[[UIImage tim_imageWithBundleAsset:@"other_voice1"], [UIImage tim_imageWithBundleAsset:@"other_voice2"], [UIImage tim_imageWithBundleAsset:@"other_voice3"]];
    }
    else
    {
        _soundButton.imageView.animationImages = @[[UIImage tim_imageWithBundleAsset:@"other_voice1"], [UIImage tim_imageWithBundleAsset:@"other_voice2"], [UIImage tim_imageWithBundleAsset:@"other_voice3"]];
    }
    
    _soundButton.imageView.animationDuration = 0.5;
    _soundButton.imageView.animationRepeatCount = 0;
    [_soundButton.imageView startAnimating];
}

- (void)stopPlaySoundAnimating {
    [_soundButton.imageView stopAnimating];
    _soundButton.imageView.animationImages = nil;
}

- (void)startPlaySound {
    [self startPlaySoundAnimating];
    TIMSoundElem *elem = (TIMSoundElem *)[_msg.msg getElem:0];
    __weak TSChatSoundTableViewCell *ws = self;
    
    NSString *cache = [PathUtility getCachePath];
    NSString *loginId = [[TIMManager sharedInstance] getLoginUser];
    NSString *audioDir = [NSString stringWithFormat:@"%@/%@",cache,loginId];
    BOOL isDir = FALSE;
    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir];
    if (!(isDir && isDirExist))
    {
        BOOL isCreateDir = [PathUtility createDirectoryAtCache:loginId];
        if (!isCreateDir) {
            return;
        }
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",cache,loginId,elem.uuid];
    if ([PathUtility isExistFile:path])
    {
        NSURL *url = [NSURL fileURLWithPath:path];
        [[ChatSoundPlayer sharedInstance] playWithUrl:url finish:^{
            [ws stopPlaySoundAnimating];
        }];
    }
    else
    {
        [elem getSound:path succ:^{
            NSURL *url = [NSURL fileURLWithPath:path];
            [[ChatSoundPlayer sharedInstance] playWithUrl:url finish:^{
                [ws stopPlaySoundAnimating];
            }];
        } fail:^(int code, NSString *msg) {
            NSLog(@"path--->%@",path);
//            [[HUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"播放语音失败:%@，path=%@", IMALocalizedError(code, msg),path]];
            NSLog(@"播放语音失败");
        }];
    }
}

- (void)stopPlaySound
{
    [self stopPlaySoundAnimating];
    [[ChatSoundPlayer sharedInstance] stopPlay];
}

- (void)onPlaySound
{
    if (!_soundButton.imageView.isAnimating)
    {
        [self startPlaySound];
    }
    else
    {
        // 正在播放，再次点击，则停止播放
        [self stopPlaySound];
    }
}

@end

@implementation TSChatFileTableViewCell

@end

@implementation TSChatVideoTableViewCell

- (UIView *)addElemContent {
    _videoPanel = [[MicroVideoPlayView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    return _videoPanel;
}

- (void)configContent {
    [super configContent];
    
    [_videoPanel setMessage:_msg];
}

@end
