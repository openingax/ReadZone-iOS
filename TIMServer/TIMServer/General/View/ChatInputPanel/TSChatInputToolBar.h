//
//  TSChatInputToolBar.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatInputBaseView.h"

@class TSChatInputToolBar;
@protocol TSChatInputToolBarDelegate <NSObject>

- (void)onToolBarClickPhoto:(TSChatInputToolBar *)bar show:(BOOL)isShow;
- (void)onToolBarClickMovie:(TSChatInputToolBar *)bar show:(BOOL)isShow;

@end

@interface TSChatInputToolBar : TSChatInputBaseView <UITextViewDelegate>
{
@protected
    UIButton                *_audioBtn;
@protected
    UIButton                *_audioPressedBtn;
    UITextView              *_textView;
    
@protected
    UIButton                *_photoBtn;
    
@protected
    UIButton                *_movieBtn;
    
@protected
    NSTimer                 *_inputStatusTimer;
    BOOL                    _isInLoop;//每3秒执行一次，如果在3秒之内，则不发送输入状态
    
@protected
    __weak id<TSChatInputToolBarDelegate> _toolBarDelegate;
}

@property (nonatomic, weak) id<TSChatInputToolBarDelegate> toolBarDelegate;

- (BOOL)isEditing;

- (void)setInputText:(NSString *)text;

@end

@interface TSRichChatInputToolBar : TSChatInputToolBar

- (TSIMMsg *)getMsgDraft;

- (void)setMsgDraft:(TSIMMsg *)draft;

@end
