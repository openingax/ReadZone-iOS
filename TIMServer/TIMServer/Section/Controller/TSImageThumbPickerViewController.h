//
//  TSImageThumbPickerViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/28.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+CommonBlock.h"

@interface TSImageThumbPickerViewController : UIViewController
{
@protected
    UIImage         *_showImage;
    UIImageView     *_imageView;
    BOOL            _bIsSendOriPic;
}
@property (nonatomic, readonly) UIImage *showImage;
@property (nonatomic, copy) CommonCompletionBlock sendImageBlock;

- (instancetype)initWith:(UIImage *)image;

@end
