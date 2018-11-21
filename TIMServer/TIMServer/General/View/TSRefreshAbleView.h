//
//  TSRefreshAbleView.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSRefreshAbleView <NSObject>

@property (nonatomic, assign) NSInteger refreshHeight;

- (void)willLoading;
- (void)releaseLoading;
- (void)loading;
- (void)loadingOver;

@end
