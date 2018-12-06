//
//  TSBaseViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSAlertManager.h"
#import "TSDebugMarco.h"
#import "TSColorMarco.h"
#import <CoreServices/CoreServices.h>
#import <Masonry.h>
#import "CommonLibrary.h"

@interface TSBaseViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic,strong) UIImageView *backgroundView;
@property(nonatomic,assign) BOOL asChild;
@property(nonatomic,assign) CGSize childSize;

- (BOOL)hasBackgroundView;
- (void)configParams;
- (void)addBackground;
- (void)configBackground;
- (void)layoutBackground;

- (void)callImagePickerActionSheet;

// 对于界面上有输入框的，可以选择性调用这个方法进行收起键盘
- (void)addTapBlankToHideKeyboardGesture;

@end
