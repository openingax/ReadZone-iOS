//
//  TSManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * kTIMLoginSuccEvent = @"kTIMLoginSuccEvent";
static NSString * kTIMNewMsgEvent = @"kTIMNewMsgEvent";

@interface TSManager : NSObject

- (void)showTIMWithController:(UIViewController *)controller;
- (void)loginTIMWithAccount:(NSString *)account
                   nickName:(NSString *)nickName
                    faceURL:(NSString *)faceURL
                   deviceID:(NSString *)deviceID;
- (void)clearVC;
- (void)logoutTIM;

@end
