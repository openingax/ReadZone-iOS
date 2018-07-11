//
//  RZAPILogin.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/11.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import "RZAPI.h"

@interface RZAPILogin : RZAPI

@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *password;

@end
