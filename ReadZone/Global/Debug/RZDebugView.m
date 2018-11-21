//
//  RZDebugView.m
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import "RZDebugView.h"

@interface RZDebugView ()

@property(nonatomic,strong) UITextView *textView;

@end

@implementation RZDebugView

- (instancetype)init {
    if (self = [super init]) {
        _textView = [[UITextView alloc] init];
        _textView.userInteractionEnabled = NO;
        _textView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:10 weight:UIFontWeightLight];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearAction)];
        tapGes.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGes];
        
//        NSString *title = RZLocalizedString(@"DEBUG_LOG_CLEAR_BTN", @"Debug 视图的清除按钮");
//        NSMutableAttributedString *attrStrNor = [[NSMutableAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12 weight:UIFontWeightRegular], NSFontAttributeName, nil]];
//        NSMutableAttributedString *attrStrSelected = [[NSMutableAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12 weight:UIFontWeightRegular], NSFontAttributeName, nil]];
//
//        UIButton *clearBtn = [[UIButton alloc] init];
//        [clearBtn setAttributedTitle:attrStrNor forState:UIControlStateNormal];
//        [clearBtn setAttributedTitle:attrStrSelected forState:UIControlStateHighlighted];
//
//        clearBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//        clearBtn.layer.borderWidth = 1.f;
//        clearBtn.layer.cornerRadius = 2;
//        clearBtn.layer.masksToBounds = YES;
//
//        [clearBtn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:clearBtn];
//        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self).with.offset(-4);
//            make.centerX.equalTo(self);
//        }];
    }
    return self;
}

- (void)debugLog:(id)log {
    if ([NSString isEmptyString:_textView.text]) {
        _textView.text = [NSString stringWithFormat:@"%@", log];
    } else {
        _textView.text = [NSString stringWithFormat:@"%@\n%@", _textView.text, log];
    }
}

- (void)clearAction {
    _textView.text = @"";
}

- (id)log {
    return self.textView.text;
}

@end
