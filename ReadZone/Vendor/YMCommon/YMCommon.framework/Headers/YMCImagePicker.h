//
//  YMCImagePicker.h
//  YMCommon
//
//  Created by liushilou on 17/3/27.
//  Copyright © 2017年 yunmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YMCImagePicker : NSObject

//@property (assign, nonatomic) NSInteger maxImageCount; //初始后，调用openWithController 之前设置


- (void)openWithController:(UIViewController *)controller maxImageCount:(NSInteger)maxImageCount loadOldImage:(BOOL)load completeBlock:(void (^)(NSArray *))block;



@end
