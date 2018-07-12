//
//  RZHotPotModel.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/7/12.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface RZHotPotModel : AVObject<AVSubclassing>

@property(nonatomic,strong) UIImage *hotPotImg;
@property(nonatomic,copy) NSString *headlineStr;
@property(nonatomic,copy) NSString *sourceStr;

@end
