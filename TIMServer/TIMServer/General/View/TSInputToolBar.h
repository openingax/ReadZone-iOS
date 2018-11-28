//
//  TSInputToolBar.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/30.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseView.h"

@class TSInputToolBar;

@protocol TSInputToolBarDelegate <NSObject>

@required
- (void)toolBar:(TSInputToolBar *)toolBar didClickSendButton:(NSString *)content;
- (void)toolBarDidClickPhotoButton;
- (void)toolBarDidClickMovieButton;

@end

@interface TSInputToolBar : TSBaseView <UITextViewDelegate>
{
@protected
    NSInteger       _contentHeight;
@protected
    UIButton        *_audioBtn;
    UIButton        *_audioPressed;
    UITextView      *_textView;
    UIButton        *_photoBtn;
    UIButton        *_movieBtn;

@protected
    NSTimer         *_inputStatusTime;
    BOOL            isInLoop;
}

@property(nonatomic,weak) id <TSInputToolBarDelegate>delegate;
@property(nonatomic,assign) NSInteger contentHeight;
@property(nonatomic,assign) BOOL isPoping;

- (BOOL)isEditing;
- (void)setInputText:(NSString *)text;

@end
