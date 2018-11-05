//
//  YMBaseAPIManager.h
//  WaterPurifier
//
//  Created by 刘世楼 on 16/5/16.
//  Copyright © 2016年 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMCNetErrorView.h"



//已崩～各种返回格式～，妈蛋的。。
/*解决:#import YMCBaseAPIManager.h YMCRequestType 重复定义的问题
 * by：Chengmin Zhang - 2017/2/14
 */
#ifndef YMCREQUESTTYPE_ENUM
#define YMCREQUESTTYPE_ENUM
typedef NS_ENUM(NSInteger, YMCRequestType) {
    YMCRequestTypeAppstore,
    YMCRequestTypeXiaomi,
    YMCRequestTypeXiaomiProps,
    YMCRequestTypeYunmi,
    YMCRequestTypeReact,
    YMCRequestTypeQuanxin,//权新的接口
    YMCRequestTypeBaidu,
    YMCRequestTypeImage,
};
#endif

@protocol YMCBaseAPIManagerDelegate <NSObject>

@required
- (void)YMCBaseAPIManagerTokenTimeOut;

@end




@interface YMCBaseAPIManager : NSObject

@property (nonatomic,weak) id<YMCBaseAPIManagerDelegate> delegate;

-(void)asynPostToUrl:(NSString*)url widthData:(NSDictionary*)data type:(YMCRequestType)type completeBlock:(void (^)(YMCRequestStatus status,NSString *message,NSDictionary *data))block;

- (void)asynPostToUrl:(NSString *)url formdata:(NSDictionary *)data type:(YMCRequestType)type completeBlock:(void (^)(YMCRequestStatus status,NSString *message,id data))block;


-(void)asynGetToUrl:(NSString*)url type:(YMCRequestType)type completeBlock:(void (^)(YMCRequestStatus status,NSString *message,id data))block;

-(void)asynGetToUrl:(NSString*)url type:(YMCRequestType)type params:(NSDictionary *)params completeBlock:(void (^)(YMCRequestStatus status,NSString *message,id data))block;

-(void)asynPutToUrl:(NSString*)url widthData:(NSDictionary*)data type:(YMCRequestType)type completeBlock:(void (^)(YMCRequestStatus status,NSString *message,NSDictionary *data))block;

-(void)asynDeleteToUrl:(NSString*)url type:(YMCRequestType)type params:(NSDictionary *)params completeBlock:(void (^)(YMCRequestStatus status,NSString *message,id data))block;

//-(void)asynGetimageByurl:(NSString *)imageurl completeBlock:(void (^)(requestStatus status,UIImage *image))block;

- (void)uploadImageToUrl:(NSString *)url images:(NSArray *)images token:(NSString *)token completeBlock:(void (^)(YMCRequestStatus status,NSString *message,id data))block;



- (void)cancle;

@end
