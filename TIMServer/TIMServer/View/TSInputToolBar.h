//
//  TSInputToolBar.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/30.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSInputToolBar;

@protocol TSInputToolBarDelegate <NSObject>

- (void)toolBar:(TSInputToolBar *)toolBar didClickSendButton:(NSString *)content;

@end

@interface TSInputToolBar : UIView <UITextViewDelegate>
{
@protected
    NSInteger       _contentHeight;
@protected
    UIButton        *_audioBtn;
    UIButton        *_audioPressed;
    UITextView      *_textView;
    UIButton        *_imgBtn;
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
