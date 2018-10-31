//
//  TSBaseViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSBaseViewController : UIViewController

@property(nonatomic,strong) UIImageView *backgroundView;
@property(nonatomic,assign) BOOL asChild;

- (BOOL)hasBackgroundView;
- (void)configParams;
- (void)addBackground;
- (void)configBackground;
- (void)layoutBackground;

@end
