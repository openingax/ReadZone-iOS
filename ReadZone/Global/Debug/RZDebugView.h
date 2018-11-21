//
//  RZDebugView.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZDebugView : UIView

@property(nonatomic,strong,readonly) id log;

- (void)debugLog:(id)log;

@end
