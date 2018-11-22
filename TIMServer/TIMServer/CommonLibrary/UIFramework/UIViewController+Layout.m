//
//  UIViewController+Layout.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "UIViewController+Layout.h"

@implementation UIViewController (Layout)

- (void)layoutOnViewDidAppear {
    
}

- (void)layoutSubviewsFrame {
    
    if (CGRectIsEmpty(self.view.bounds)) {
        return;
    }
    
    [self layoutOnIPhone];
}

- (void)layoutOnIPhone {
    
}

- (void)layoutOnViewWillAppear
{
    [self layoutSubviewsFrame];
}

- (void)addOwnViews {
    
}

- (void)configOwnViews {
    
}

@end
