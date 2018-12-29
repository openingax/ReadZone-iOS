//
//  TSUGCVideoPreviewViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/12/29.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TSUGCVideoPreviewViewControllerDelegate <NSObject>

- (void)previewVideoPath:(NSString *)path;

@end

@interface TSUGCVideoPreviewViewController : TSBaseViewController

@property(nonatomic,weak) id <TSUGCVideoPreviewViewControllerDelegate> delegate;

- (instancetype)initWithVideoPath:(NSString *)videoPath coverImgPath:(NSString *)coverImgPath;

@end

NS_ASSUME_NONNULL_END
