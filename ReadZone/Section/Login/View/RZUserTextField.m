//
//  RZUserTextField.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/10.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZUserTextField.h"
#import "QCMethod.h"

@interface RZUserTextField () <UITextFieldDelegate, CAAnimationDelegate>

@property(nonatomic,assign) RZUserTextFieldType type;
@property(nonatomic,strong) UILabel *placeholderLabel;
@property(nonatomic,strong) UIView *bottomLine;

@property(nonatomic,strong) NSMutableDictionary *layers;
@property(nonatomic,strong) NSMapTable *completionBlocks;
@property(nonatomic,assign) BOOL updateLayerValueForCompletedAnimation;

@end

@implementation RZUserTextField

#pragma mark - Life Cycle

- (instancetype)initWithType:(RZUserTextFieldType)type
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        self.type = type;
        self.backgroundColor = [UIColor clearColor];
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.secureTextEntry = type == RZUserTextFieldTypePassword ? YES : NO;
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        // 处理占位符
        [self addSubview:self.placeholderLabel];
        if (type == RZUserTextFieldTypeAccount) {
            self.placeholderLabel.text = RZLocalizedString(@"LOGIN_PLACEHOLDER_ACCOUNT", @"账号输入框的占位符");
        } else if (type == RZUserTextFieldTypePassword) {
            self.placeholderLabel.text = RZLocalizedString(@"LOGIN_PLACEHOLDER_PWD", @"密码输入框的占位符");
        } else if (type == RZUserTextFieldTypeAuthCode) {
            self.placeholderLabel.text = RZLocalizedString(@"LOGIN_PLACEHOLDER_AUTH_CODE", @"验证码输入框的占位符");
        }
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
        [self addSubview:self.bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
//        [self setupProperties];
//        [self setupLayers];
    }
    return self;
}

#pragma mark - Event
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([NSString isEmptyString:textField.text]) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.centerY.equalTo(self);
            }];
            self.placeholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        }];
    } else {
        [UIView animateWithDuration:0.6 animations:^{
            [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.top.equalTo(self).with.offset(-10);
            }];
            self.placeholderLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self addUntitled1AnimationWithShow:YES];
    //    [UIView animateWithDuration:0.6 animations:^{
    //        [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.height.mas_equalTo(1.5);
    //        }];
    //        self.bottomLine.backgroundColor = [UIColor blackColor];
    //    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if ([NSString checkIsEmptyOrNull:textField.text]) {
    //        [UIView animateWithDuration:0.8 animations:^{
    //            [self.placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
    //                make.left.equalTo(self);
    //                make.centerY.equalTo(self);
    //            }];
    //            self.placeholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    //
    //            [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
    //                make.height.mas_equalTo(0.5);
    //            }];
    //            self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
    //        }];
    //    } else {
    //        [UIView animateWithDuration:0.8 animations:^{
    //            [self.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
    //                make.height.mas_equalTo(0.5);
    //            }];
    //            self.bottomLine.backgroundColor = [UIColor rz_colorwithRed:0 green:0 blue:0 alpha:0.15];
    //        }];
    //    }
    [self addUntitled1AnimationWithShow:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

#pragma mark - Setter & Getter
- (void)setPlaceholder:(NSString *)placeholder
{
    if ([NSString isEmptyString:placeholder]) {
        self.placeholderLabel.text = RZLocalizedString(self.type == RZUserTextFieldTypeAccount ? @"LOGIN_PLACEHOLDER_ACCOUNT" : @"LOGIN_PLACEHOLDER_PWD", @"输入框的占位符");
    } else {
        self.placeholderLabel.text = placeholder;
    }
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor rz_colorwithRed:153 green:150 blue:153 alpha:1];
        _placeholderLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    }
    return _placeholderLabel;
}

#pragma mark -
- (void)setupProperties
{
    self.completionBlocks = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];
    self.layers = [NSMutableDictionary dictionary];
}

- (void)setupLayers{
    self.backgroundColor = [UIColor colorWithRed:1 green: 1 blue:1 alpha:1];
    
    CATextLayer * text = [CATextLayer layer];
    text.frame = CGRectMake(0.5, 38.82, 97, 20.05);
    [self.layer addSublayer:text];
    self.layers[@"text"] = text;
    
    [self resetLayerPropertiesForLayerIdentifiers:nil];
}

- (void)resetLayerPropertiesForLayerIdentifiers:(NSArray *)layerIds{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if(!layerIds || [layerIds containsObject:@"text"]){
        CATextLayer * text = self.layers[@"text"];
        text.contentsScale   = [[UIScreen mainScreen] scale];
        text.string          = @"Hello World!";
        text.font            = (__bridge CFTypeRef)@"Helvetica";
        text.fontSize        = 16;
        text.alignmentMode   = kCAAlignmentCenter;
        text.foregroundColor = [UIColor blackColor].CGColor;
    }
    
    [CATransaction commit];
}

#pragma mark - Animation Setup
- (void)addUntitled1AnimationWithShow:(BOOL)isShow {
    [self addUntitled1AnimationCompletionBlock:nil isShow:isShow];
}

- (void)addUntitled1AnimationCompletionBlock:(void (^)(BOOL finished))completionBlock isShow:(BOOL)isShow {
    if (completionBlock){
        CABasicAnimation * completionAnim = [CABasicAnimation animationWithKeyPath:@"completionAnim"];;
        completionAnim.duration = 0.304;
        completionAnim.delegate = self;
        [completionAnim setValue:@"Untitled1" forKey:@"animId"];
        [completionAnim setValue:@(NO) forKey:@"needEndAnim"];
        [self.layer addAnimation:completionAnim forKey:@"Untitled1"];
        [self.completionBlocks setObject:completionBlock forKey:[self.layer animationForKey:@"Untitled1"]];
    }
    
    NSString * fillMode = kCAFillModeForwards;
    
    ////Text animation
    CAKeyframeAnimation * textFontSizeAnim = [CAKeyframeAnimation animationWithKeyPath:@"fontSize"];
    if (isShow) {
        textFontSizeAnim.values            = @[@16, @12];
    } else {
        textFontSizeAnim.values            = @[@12, @16];
    }
    textFontSizeAnim.keyTimes              = @[@0, @1];
    textFontSizeAnim.duration              = 0.3;
    
    CAKeyframeAnimation * textForegroundColorAnim = [CAKeyframeAnimation animationWithKeyPath:@"foregroundColor"];
    if (isShow) {
        textForegroundColorAnim.values         = @[(id)[UIColor colorWithRed:0 green: 0 blue:0 alpha:0.5].CGColor,
                                                   (id)[UIColor colorWithRed:0 green: 0.316 blue:1 alpha:1].CGColor];
    } else {
        textForegroundColorAnim.values = @[(id)[UIColor colorWithRed:0 green: 0.316 blue:1 alpha:1].CGColor,
        (id)[UIColor colorWithRed:0 green: 0 blue:0 alpha:0.5].CGColor];
    }
    textForegroundColorAnim.keyTimes       = @[@0, @1];
    textForegroundColorAnim.duration       = 0.3;
    
    CAAnimationGroup * textUntitled1Anim = [QCMethod groupAnimations:@[textFontSizeAnim, textForegroundColorAnim] fillMode:fillMode];
    [self.layers[@"text"] addAnimation:textUntitled1Anim forKey:@"textUntitled1Anim"];
}

#pragma mark - Animation Cleanup

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    void (^completionBlock)(BOOL) = [self.completionBlocks objectForKey:anim];;
    if (completionBlock){
        [self.completionBlocks removeObjectForKey:anim];
        if ((flag && self.updateLayerValueForCompletedAnimation) || [[anim valueForKey:@"needEndAnim"] boolValue]){
            [self updateLayerValuesForAnimationId:[anim valueForKey:@"animId"]];
            [self removeAnimationsForAnimationId:[anim valueForKey:@"animId"]];
        }
        completionBlock(flag);
    }
}

- (void)updateLayerValuesForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"Untitled1"]){
        [QCMethod updateValueFromPresentationLayerForAnimation:[self.layers[@"text"] animationForKey:@"textUntitled1Anim"] theLayer:self.layers[@"text"]];
    }
}

- (void)removeAnimationsForAnimationId:(NSString *)identifier{
    if([identifier isEqualToString:@"Untitled1"]){
        [self.layers[@"text"] removeAnimationForKey:@"textUntitled1Anim"];
    }
}

- (void)removeAllAnimations{
    [self.layers enumerateKeysAndObjectsUsingBlock:^(id key, CALayer *layer, BOOL *stop) {
        [layer removeAllAnimations];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    //textfield在iOS11 内存泄漏。没有执行dealloc，据说是私有变量provider的问题
    [super willMoveToSuperview:newSuperview];
    if (@available(iOS 11.0, *)) {//a temp solution to fix { UITextField private-var retaincycle.}
        if (!newSuperview) {
            NSString *keyPath = @"textContentView.provider";
            [self setValue:nil forKeyPath:keyPath];
        }
    }
}

- (BOOL)willDealloc
{
    //密码框存在内存问题，(这个内存问题不是很严重，因为只要下一次遇到textfield获取焦点，就会释放)
    //没有好的办法处理这个问题
    //一个办法：在离开页面时，remove掉就可以，但是在dealloc里remove不行，逻辑处理麻烦。
    if (self.secureTextEntry) {
        return NO;
    }else{
        return YES;
    }
}

@end
