//
//  TSAlertManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSAlertManager.h"

@implementation TSAlertManager

+ (void)showMessage:(NSString *)msg {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:action];
    [[[UIApplication sharedApplication].keyWindow.rootViewController presentedViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
