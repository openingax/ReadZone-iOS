//
//  YMProjectConfig.h
//  YMCommon
//
//  Created by liushilou on 16/12/23.
//  Copyright © 2016年 yunmi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#ifdef DEBUG
#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...);
#endif

#define YMC_FONT(s) [UIFont systemFontOfSize:s]
//[UIFont fontWithName:@"DINCond-Medium" size:s]

//屏幕尺寸
#define YMC_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define YMC_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



typedef NS_ENUM(NSInteger, YMCProjectModel) {
    YMCProjectNormal,//正式环境
    YMCProjectTest,//测试环境
//    YMCProjectTestServer,//测试版，需要启动服务
//    YMCProjectTestPackage,//测试版，本地包
};




@interface YMCProjectConfig : NSObject

//默认云米主题色
@property (nonatomic,strong) UIColor *brandColor;
//默认白色
@property (nonatomic,strong) UIColor *navigationBarTiniColor;
//默认#f5f5f5
@property (nonatomic,strong) UIColor *backgroundColor;
//默认#E5E5E5
@property (nonatomic,strong) UIColor *lineColor;
//默认#333333
@property (nonatomic,strong) UIColor *titleColor;
//默认#999999
@property (nonatomic,strong) UIColor *detailsColor;

//默认正式环境
@property (nonatomic,assign) YMCProjectModel workmode;

//默认正式环境
@property (nonatomic,strong) NSString *source;
//域名
@property (nonatomic,strong) NSString *baseUrl;


+ (YMCProjectConfig *)shareInstance;

//使用brandColor为背景的导航栏＋白色的返回按钮
//如果要使用自定义的brandColor，需要在设置brandColor之后再调用
- (void)userDefaultNavigationBarStyle;

- (UIImage *)backImage;

@end
