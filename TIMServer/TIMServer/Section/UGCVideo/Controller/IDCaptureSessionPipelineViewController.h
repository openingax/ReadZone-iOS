//
//  IDCaptureSessionPipelineViewController.h
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "TSBaseViewController.h"

@protocol IDCaptureSessionPipelineViewControllerDelegaate <NSObject>

- (void)recordVideoPath:(NSString *)path;

@end

@interface IDCaptureSessionPipelineViewController : TSBaseViewController

@property(nonatomic,weak) id <IDCaptureSessionPipelineViewControllerDelegaate> delegate;

@end
