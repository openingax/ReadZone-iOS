//
//  TSAlertManager.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSAlertManager.h"
#import "TSIMManager.h"

@implementation TSAlertManager

+ (void)showMessage:(NSString *)msg {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:action];
    [[TSIMManager shareInstance].topViewController presentViewController:alertController animated:YES completion:nil];
}

@end
