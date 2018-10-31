//
//  TSInputToolBar.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/30.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSInputToolBar : UIView
{
@protected
    NSInteger       _contentHeight;
@protected
    UIButton        *_audioBtn;
    UIButton        *_audioPressed;
    UITextView      *_textView;
    UIButton        *_emojBtn;
    UIButton        *_moreBtn;

@protected
    NSTimer         *_inputStatusTime;
    BOOL            isInLoop;
}

@property(nonatomic,assign) NSInteger contentHeight;

- (BOOL)isEditing;
- (void)setInputText:(NSString *)text;

@end
