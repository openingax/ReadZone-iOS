//
//  TSIMServerViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TSIMServerViewController : TSBaseViewController
{
@protected
    NSMutableArray *_currentMsgs;
}

@property(nonatomic,strong) NSMutableArray *currentMsgs;

- (void)didReceiveNewMsg;

@end

NS_ASSUME_NONNULL_END
