//
//  TSInputToolBar.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/30.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "TSInputToolBar.h"
#import "CommonLibrary.h"
#import "TIMServerHelper.h"
#import "TSConstMarco.h"
#import "UIView+Layout.h"
#import "TSConstMarco.h"

@implementation TSInputToolBar

#define kButtonSize 36
#define kTextViewMaxHeight 72
#define kVerMargin 7
#define kDefaultMargin  8

//chat toolbar
#define kChatToolBarMinHeight 36
#define kChatToolBarMaxHeight 72
#define kChatToolBarHorPadding 8
#define kChatToolBarVerPadding 5
#define kChatToolBarMorBtnSize 50
#define kChatToolBarMoreLabelPadding 3
#define kChatToolBarMoreLabelHeight 14
#define kChatToolBarMoreBtnVerPadding 10

- (instancetype)init {
    if (self = [super init]) {
        // iPX 84，其余 50
        _contentHeight = kIsiPhoneX ? 84 : 50;
        self.backgroundColor = RGBOF(0xEEEEEE);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidChangeFrameNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - DrawView

- (void)addOwnViews {
    
    _audioBtn = [[UIButton alloc] init];
    [_audioBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
    [_audioBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_voice_press"] forState:UIControlStateHighlighted];
    [_audioBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_keyboard_nor"] forState:UIControlStateSelected];
    [_audioBtn addTarget:self action:@selector(onAudioBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audioBtn];
    
    // 语音按钮
    _audioPressed = [[UIButton alloc] init];
    _audioPressed.titleLabel.font = kTimMiddleTextFont;
    _audioPressed.layer.cornerRadius = 6;
    _audioPressed.layer.borderColor = kGrayColor.CGColor;
    _audioPressed.layer.shadowColor = kBlackColor.CGColor;
    _audioPressed.layer.shadowOffset = CGSizeMake(1, 1);
    _audioPressed.layer.borderWidth = 0.5;
    _audioPressed.layer.masksToBounds = YES;
    [_audioPressed setBackgroundImage:[UIImage imageWithColor:RGBOF(0xEEEEEE)] forState:UIControlStateNormal];
    [_audioPressed setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
    [_audioPressed setTitleColor:kGrayColor forState:UIControlStateNormal];
    
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_PRESS_SAY", @"按住 说话") forState:UIControlStateNormal];
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_LOOSE_END", @"松开 结束") forState:UIControlStateSelected];
    
    [_audioPressed addTarget:self action:@selector(onClickRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_audioPressed addTarget:self action:@selector(onClickRecordDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_audioPressed addTarget:self action:@selector(onClickRecordDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_audioPressed addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_audioPressed addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpInside];
    
    _audioPressed.hidden = YES;
    [self addSubview:_audioPressed];
    
    _textView = [self inputTextView];
    _textView.frame = CGRectMake(0, 0, self.frame.size.width, kChatToolBarMinHeight);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.enablesReturnKeyAutomatically = YES;
    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.f].CGColor;
    _textView.layer.borderWidth = 0.6;
    _textView.layer.cornerRadius = 6;
    _textView.font = kTimLargeTextFont;
    _textView.textContainerInset = UIEdgeInsetsMake(6, 6, 6, 6);
    [self addSubview:_textView];
    
    // emoj 按钮
    _emojBtn = [[UIButton alloc] init];
    [_emojBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_smile_nor"] forState:UIControlStateNormal];
    [_emojBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_smile_press"] forState:UIControlStateHighlighted];
    [_emojBtn addTarget:self action:@selector(onEmojClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_emojBtn];
    
    // more 按钮
    _moreBtn = [[UIButton alloc] init];
    [_moreBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_more_nor"] forState:UIControlStateNormal];
    [_moreBtn setImage:[UIImage imageWithBundleAsset:@"chat_toolbar_more_press"] forState:UIControlStateHighlighted];
    [_moreBtn addTarget:self action:@selector(onMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_audioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kButtonSize, kButtonSize));
        make.top.equalTo(self).with.offset(kVerMargin);
        make.left.equalTo(self).with.offset(kDefaultMargin);
    }];
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kButtonSize, kButtonSize));
        make.top.equalTo(self).with.offset(kVerMargin);
        make.right.equalTo(self).with.offset(-kDefaultMargin);
    }];
    
    [_emojBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kButtonSize, kButtonSize));
        make.top.equalTo(self).with.offset(kVerMargin);
        make.right.equalTo(self->_moreBtn.mas_left).with.offset(-kDefaultMargin/2);
    }];
    
    [_audioPressed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kButtonSize);
        make.top.equalTo(self->_audioBtn.mas_top);
        make.left.equalTo(self->_audioBtn.mas_right).with.offset(kDefaultMargin/2);
        make.right.equalTo(self->_emojBtn.mas_left).with.offset(-kDefaultMargin/2);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kButtonSize);
        make.top.equalTo(self->_audioBtn.mas_top);
        make.left.equalTo(self->_audioBtn.mas_right).with.offset(kDefaultMargin/2);
        make.right.equalTo(self->_emojBtn.mas_left).with.offset(-kDefaultMargin/2);
    }];
    
    //    [_audioBtn sizeWith:CGSizeMake(kButtonSize, kButtonSize)];
    //    [_audioBtn alignParentTopWithMargin:kVerMargin];
    //    [_audioBtn alignParentLeftWithMargin:kDefaultMargin];
    //
    //    [_moreBtn sameWith:_audioBtn];
    //    [_moreBtn alignParentRightWithMargin:kDefaultMargin];
    //
    //    [_emojBtn sameWith:_moreBtn];
    //    [_emojBtn layoutToLeftOf:_moreBtn margin:kDefaultMargin/2];
    //
    //    [_audioPressed sameWith:_audioBtn];
    //    [_audioPressed layoutToRightOf:_audioBtn margin:kDefaultMargin/2];
    //    [_audioPressed scaleToLeftOf:_emojBtn margin:kDefaultMargin/2];
    //
    //    CGRect rect = self.bounds;
    //    CGRect apFrame = _audioPressed.frame;
    //
    //    rect.origin.x = apFrame.origin.x;
    //    rect.origin.y = kVerMargin;
    //    rect.size.height = rect.size.height - 2 * kVerMargin - kIsiPhoneX ? 34 : 0;
    //    rect.size.width = apFrame.size.width;
    //    _textView.frame = rect;
}

- (void)configOwnViews {
    
}


#pragma mark - Notification
- (void)onKeyboardDidShow:(NSNotification *)noti {
    if ([self isEditing]) {
        NSDictionary *userInfo = noti.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGFloat contentHeight = kIsiPhoneX ? (endFrame.size.height + _contentHeight - 34) : (endFrame.size.height + _contentHeight);
        if (contentHeight != _contentHeight) {
            CGRect rect = self.frame;
            rect.origin.y = kIsiPhoneX ? (endFrame.origin.y - _contentHeight + 34 - kNavTotalHeight) : (endFrame.origin.y - _contentHeight - kNavTotalHeight);
            rect.size.height = contentHeight;
            
            [UIView animateWithDuration:duration animations:^{
                self.frame = rect;
                //                self.contentHeight = contentHeight;
            }];
        }
    }
}

- (void)onKeyboardWillHide:(NSNotification *)noti {
    if (_isPoping) return;
    NSDictionary* userInfo = noti.userInfo;
    
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger contentHeight = kIsiPhoneX ? 84 : 50;
    
    CGRect rect = self.frame;
    rect.origin.y = kScreenHeight - contentHeight - kNavTotalHeight;
    rect.size.height = contentHeight;
    
    [UIView animateWithDuration:duration animations:^{
        self.frame = rect;
        self.contentHeight = contentHeight;
    }];
}


- (BOOL)isEditing {
    return [_textView isFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // 截取【发送】按钮事件
        
        if (_delegate && [_delegate respondsToSelector:@selector(toolBar:didClickSendButton:)]) {
            [_delegate toolBar:self didClickSendButton:textView.text];
        }
        
        return NO;
    }
    return YES;
}


#pragma mark - Action

- (void)onAudioBtnClick:(UIButton *)button {
    _audioBtn.selected = !_audioBtn.selected;
    _audioPressed.hidden = !_audioBtn.selected;
    _textView.hidden = _audioBtn.selected;
    if (_audioBtn.selected) {
        [_textView resignFirstResponder];
        [_textView endEditing:YES];
    } else {
        [_textView becomeFirstResponder];
    }
    
    _audioPressed.selected = NO;
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_PRESS_SAY", @"按住 说话") forState:UIControlStateNormal];
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_LOOSE_END", @"松开 结束") forState:UIControlStateSelected];
}

- (void)onEmojClick:(UIButton *)button {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    _moreBtn.selected = NO;
    button.selected = !button.selected;
}

- (void)onMoreClick:(UIButton *)button {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    _emojBtn.selected = NO;
    button.selected = !button.selected;
}

// 默认高度
- (void)onClickRecordTouchDown:(UIButton *)button
{
    DebugLog(@"======>>>>>>>");
    _audioPressed.selected = YES;
}

- (void)onClickRecordDragExit:(UIButton *)button
{
    _audioPressed.selected = YES;
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_PRESS_SAY", @"按住 说话") forState:UIControlStateSelected];
}

- (void)onClickRecordDragEnter:(UIButton *)button
{
    
}

- (void)onClickRecordTouchUpOutside:(UIButton *)button
{
    _audioPressed.selected = NO;
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_PRESS_SAY", @"按住 说话") forState:UIControlStateNormal];
    [_audioPressed setTitle:TIMLocalizedString(@"CHAT_WINDOW_LOOSE_END", @"松开 结束") forState:UIControlStateSelected];
}

#pragma mark - Setter & Getter

- (void)setInputText:(NSString *)text {
    _textView.text = text;
}

- (UITextView *)inputTextView {
    return [[UITextView alloc] init];
}

@end
