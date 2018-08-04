//
//  RZHomePageModel.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/8/4.
//  Copyright © 2018年 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *bookImage;

@end

@interface RZHomePageModel : NSObject

@property(nonatomic,copy) NSString *essay;
@property(nonatomic,copy) NSString *author;
@property(nonatomic,copy) NSString *essayImage;
@property(nonatomic,strong) NSArray <Book *>*books;

@end
