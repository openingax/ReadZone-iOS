//
//  YMSelectView.h
//  WaterPurifier
//
//  Created by liushilou on 16/11/21.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YMCSelectItem : NSObject

@property (nonatomic,copy) NSString *name;

@end


@protocol YMCSelectViewDeleagte <NSObject>

- (void)YMSelectViewSeleItem:(NSInteger)index;

@end




@interface YMCSelectView : UIView

@property (nonatomic,assign) id<YMCSelectViewDeleagte> delegate;

@property (nonatomic,strong) NSArray<YMCSelectItem *> *datas;

@end
