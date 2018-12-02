//
//  TSExpendButton.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/2.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSExpendButton.h"

@implementation TSExpendButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(40 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(20 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
    
}

@end
