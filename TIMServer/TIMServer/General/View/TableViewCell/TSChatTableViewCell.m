//
//  TSChatTableViewCell.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatTableViewCell.h"

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
#warning 待完善
}

- (void)configContent
{
    [super configContent];
    
    TIMImageElem *elem = (TIMImageElem *)[_msg.msg getElem:0];
    
    __weak UIImageView *wci = _chatImage;
    [elem asyncThumbImage:^(NSString *path, UIImage *image, BOOL succ, BOOL isAsync) {
        wci.image = image ? image : [UIImage imageWithBundleAsset:@"default_image"];
    } inMsg:_msg];
}

@end

@implementation TSChatSoundTableViewCell

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
