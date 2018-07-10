//
//  RZUserButton.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/10.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZUserButton : UIButton

@property(nonatomic,assign) BOOL enable;

+ (instancetype)buttonWithType:(UIButtonType)buttonType NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
              backgroundColor:(UIColor *)color
                 onPressBlock:(void(^)(void))block;

@end
