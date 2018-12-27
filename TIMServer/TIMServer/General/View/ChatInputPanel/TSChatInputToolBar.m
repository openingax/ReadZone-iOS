//
//  TSChatInputToolBar.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatInputToolBar.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#define kButtonSize 32
#define kTextViewHeight 40
#define kTextViewMaxHeight 72
#define kHorMargin 8
#define kVerMargin 7

@interface TSChatInputToolBar ()

@property(nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation TSChatInputToolBar

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = RGBAOF(0xEEEEEE, 1);
        
        self.callCenter = [[CTCallCenter alloc] init];
        
        @weakify(self); // 弱引用，否则会造成循环引用
        self.callCenter.callEventHandler = ^(CTCall * _Nonnull call) {
            
            if (call.callState == CTCallStateDialing || call.callState == CTCallStateIncoming) {
                // 当来电时，停止录音，语音是否发送取决于其录音时长
                [[ChatSoundRecorder sharedInstance] stopRecord];
            } else if (call.callState == CTCallStateDisconnected) {
                // 当电话结束时，再回到主线程更新 UI 视图
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    @strongify(self);
                    self->_audioPressedBtn.selected = NO;
                    [self->_audioPressedBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
                    [self->_audioPressedBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
                    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                });
            }
        };
    }
    return self;
}

// 手机收到来电
- (void)onPhoneCalling {
    [self onClickRecordTouchUpOutside:_audioPressedBtn];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ChatSoundPlayer destory];
    [ChatSoundRecorder destory];
}

- (void)setInputText:(NSString *)text {
    _textView.text = text;
}

- (UITextView *)inputTextView
{
    return [[UITextView alloc] init];
}

- (void)addOwnViews
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    [self addSubview:topLine];
    
    _audioBtn = [[UIButton alloc] init];
    [_audioBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_voice_nor"] forState:UIControlStateNormal];
    [_audioBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_voice_nor"] forState:UIControlStateHighlighted];
    [_audioBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_keyboard_nor"] forState:UIControlStateSelected];
    [_audioBtn addTarget:self action:@selector(onClickAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audioBtn];
    
    // 语音按钮
    _audioPressedBtn = [[UIButton alloc] init];
    _audioPressedBtn.layer.cornerRadius = 6;
    _audioPressedBtn.layer.borderColor = RGBOF(0x00A3B4).CGColor;
    _audioPressedBtn.layer.shadowColor = kBlackColor.CGColor;
    _audioPressedBtn.layer.shadowOffset = CGSizeMake(1, 1);
    _audioPressedBtn.layer.borderWidth = 0.5;
    _audioPressedBtn.layer.masksToBounds = YES;
    [_audioPressedBtn setBackgroundImage:[UIImage imageWithColor:RGBAOF(0xFFFFFF, 1)] forState:UIControlStateNormal];
    [_audioPressedBtn setBackgroundImage:[UIImage imageWithColor:kLightGrayColor] forState:UIControlStateSelected];
    
    [_audioPressedBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_audioPressedBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    _audioPressedBtn.titleLabel.font = kTimMiddleTextFont;
    [_audioPressedBtn setTitleColor:RGBOF(0x1C1C1C) forState:UIControlStateNormal];
    
    [_audioPressedBtn addTarget:self action:@selector(onClickRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_audioPressedBtn addTarget:self action:@selector(onClickRecordDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_audioPressedBtn addTarget:self action:@selector(onClickRecordDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [_audioPressedBtn addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_audioPressedBtn addTarget:self action:@selector(onClickRecordTouchUpOutside:) forControlEvents:UIControlEventTouchUpInside];
    
    _audioPressedBtn.hidden = YES;
    [self addSubview:_audioPressedBtn];
    
    _textView = [self inputTextView];
    _textView.frame = CGRectMake(0, 0, self.frame.size.width, kTextViewHeight);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.scrollEnabled = YES;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _textView.delegate = self;
    _textView.layer.borderColor = RGBOF(0x00A3B4).CGColor;
    _textView.layer.borderWidth = 0.6;
    _textView.layer.cornerRadius = 6;
    _textView.font = kTimLargeTextFont;
    _textView.textContainerInset = UIEdgeInsetsMake(10, 6, 10, 6);
    
    [self addSubview:_textView];
    
    _photoBtn = [[UIButton alloc] init];
    [_photoBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_photo_nor"] forState:UIControlStateNormal];
    [_photoBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_photo_nor"] forState:UIControlStateHighlighted];
    [_photoBtn addTarget:self action:@selector(onClikPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoBtn];
    
    _movieBtn = [[UIButton alloc] init];
    [_movieBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_video_nor"] forState:UIControlStateNormal];
    [_movieBtn setImage:[UIImage tim_imageWithBundleAsset:@"chat_toolbar_video_nor"] forState:UIControlStateHighlighted];
    [_movieBtn addTarget:self action:@selector(onClickMovie:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_movieBtn];
}

- (void)setChatDelegate:(id<TSChatInputAbleViewDelegate>)chatDelegate {
    _chatDelegate = chatDelegate;
    [ChatSoundRecorder sharedInstance].recorderDelegate = chatDelegate;
}

#pragma mark - Action
- (void)onClickAudio:(UIButton *)button {
    
    _audioBtn.selected = !_audioBtn.selected;
    _audioPressedBtn.hidden = !_audioBtn.selected;
    _textView.hidden = _audioBtn.selected;
    
    _audioPressedBtn.selected = NO;
    [_audioPressedBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_audioPressedBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    if (!_audioPressedBtn.hidden)
    {
        if ([_textView isFirstResponder])
        {
            [_textView resignFirstResponder];
        }
        // 语音模式
        NSInteger toh = kTextViewHeight + 10;
        if (kIsiPhoneX) {
            toh = kTextViewHeight + 10 + 34;
        }
        if (toh != _contentHeight)
        {
            self.contentHeight = toh;
        }
    }
    else
    {
        // 文字模式
        [self willShowInputTextViewToHeight:[self getTextViewContentH:_textView]];
    }
}

- (void)onClickRecordTouchDown:(UIButton *)button {
    DebugLog(@"======>>>>>>>");
    _audioPressedBtn.selected = YES;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[ChatSoundRecorder sharedInstance] startRecord];
}

- (void)onClickRecordDragExit:(UIButton *)button {
    _audioPressedBtn.selected = YES;
    [_audioPressedBtn setTitle:@"按住 说话" forState:UIControlStateSelected];
    [[ChatSoundRecorder sharedInstance] willCancelRecord];
}

- (void)onClickRecordDragEnter:(UIButton *)button {
    // 通知界面
    [[ChatSoundRecorder sharedInstance] continueRecord];
}

- (void)onClickRecordTouchUpOutside:(UIButton *)button {
    _audioPressedBtn.selected = NO;
    [_audioPressedBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_audioPressedBtn setTitle:@"松开 结束" forState:UIControlStateSelected];
    
    [[ChatSoundRecorder sharedInstance] stopRecord];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)relayoutFrameOfSubViews
{
    [_audioBtn sizeWith:CGSizeMake(kButtonSize, kButtonSize)];
    [_audioBtn alignParentBottomWithMargin:kIsiPhoneX ? (9 + 34) : (9)];

    [_audioBtn alignParentLeftWithMargin:kToolBarDefaultMargin/2];
    
    [_movieBtn sameWith:_audioBtn];
    [_movieBtn alignParentRightWithMargin:kToolBarDefaultMargin/2];
    
    [_photoBtn sameWith:_movieBtn];
    [_photoBtn layoutToLeftOf:_movieBtn margin:kToolBarDefaultMargin];
    
    [_audioPressedBtn sameWith:_audioBtn];
    [_audioPressedBtn marginParentTop:5];
    [_audioPressedBtn setHeight:kTextViewHeight];
    [_audioPressedBtn layoutToRightOf:_audioBtn margin:kToolBarDefaultMargin];
    [_audioPressedBtn scaleToLeftOf:_photoBtn margin:kToolBarDefaultMargin];
    
    CGRect rect = self.bounds;
    CGRect apframe = _audioPressedBtn.frame;

    rect.origin.x = apframe.origin.x;
    rect.origin.y = apframe.origin.y;
    if (kIsiPhoneX) {
        rect.size.height = rect.size.height - 10 - 34;
    } else {
        rect.size.height -= 10;
    }
    rect.size.width = apframe.size.width;
    _textView.frame = rect;
}

- (BOOL)isEditing
{
    return [_textView isFirstResponder];
}

- (void)onClikPhoto:(UIButton *)button {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    _movieBtn.selected = NO;
    button.selected = !button.selected;
    
    if ([_toolBarDelegate respondsToSelector:@selector(onToolBarClickPhoto:show:)]) {
        [_toolBarDelegate onToolBarClickPhoto:self show:button.selected];
    }
    
    if (_audioBtn.selected) {
        [self onClickAudio:_audioBtn];
    }
}

- (void)onClickMovie:(UIButton *)button {
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    _photoBtn.selected = NO;
    button.selected = !button.selected;
    
    if ([_toolBarDelegate respondsToSelector:@selector(onToolBarClickMovie:show:)]) {
        [_toolBarDelegate onToolBarClickMovie:self show:button.selected];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    CGFloat textViewToHeight = toHeight;

    if (toHeight < kTextViewHeight)
    {
        textViewToHeight = kTextViewHeight;
    }

    if (toHeight > kTextViewMaxHeight)
    {
        textViewToHeight = kTextViewMaxHeight;
    }
    
    // 如果是 iPX，要在 conHeight 里多加 34 的高度
//    NSInteger conHeight = textViewToHeight + 3 * kVerMargin;
    NSInteger conHeight = textViewToHeight + 10;
    if (kIsiPhoneX) {
        conHeight = textViewToHeight + 10 + 34;
    }
    if (_contentHeight != conHeight)
    {
        self.contentHeight = conHeight;
    }
    NSInteger off = _textView.contentSize.height - textViewToHeight;
    if (off > 0)
    {
        [_textView setContentOffset:CGPointMake(0, off) animated:YES];
    }
}

- (BOOL)resignFirstResponder {
    _photoBtn.selected = NO;
    _movieBtn.selected = NO;
    [_textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _audioPressedBtn.hidden = YES;
    _photoBtn.selected = NO;
    _movieBtn.selected = NO;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    DebugLog(@"textViewDidEndEditing");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([_chatDelegate respondsToSelector:@selector(onChatInput:sendMsg:)])
        {
            if (textView.text.length > 0)
            {
                TSIMMsg *msg = [TSIMMsg msgWithText:textView.text];
                [_chatDelegate onChatInput:self sendMsg:msg];
            }
            _textView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
        }
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark -

- (NSInteger)getTextViewContentH:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        return kTextViewHeight;
    }
    return (NSInteger)(textView.contentSize.height - 4);
}


- (void)onModifyLoopFlag:(NSTimer *)timer
{
    _isInLoop = NO;
}

@end

@implementation TSRichChatInputToolBar

- (UITextView *)inputTextView {
    return [[TSChatInputTextView alloc] init];
}

- (TSIMMsg *)getMsgDraft
{
    return [(TSChatInputTextView *)_textView getDraftMsg];
}

- (void)setMsgDraft:(TSIMMsg *)draft
{
    [(TSChatInputTextView *)_textView setDraftMsg:draft];
}

@end
