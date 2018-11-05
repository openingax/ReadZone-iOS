//
//  YMQrCodeViewController.h
//  WaterPurifier
//
//  Created by liushilou on 16/11/15.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMCQrCodeViewControllerDelegate <NSObject>
    
- (void)YMCQrCodeViewControllerScanLogin:(NSString *)clientID;

- (void)YMCQrCodeViewControllerShowSkuId:(NSString *)skuId;

- (void)YMCQrCodeViewControllerCode:(NSString *)code;

@end


@interface YMCQrCodeViewController : UIViewController

@property (nonatomic,assign) id<YMCQrCodeViewControllerDelegate> delegate;

//
@property (nonatomic,assign) BOOL feedbackContent;
    
@end
