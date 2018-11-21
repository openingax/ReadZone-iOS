//
//  TSChatInputAbleView.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSIMMsg.h"

@protocol TSChatInputAbleViewDelegate;

@protocol TSChatInputAbleView <NSObject>

@required

@property (nonatomic, weak) id<TSChatInputAbleViewDelegate> chatDelegate;

// 方便外部KVO;
@property (nonatomic, assign) NSInteger contentHeight;
//- (void)getFocus;

@end


@protocol TSChatInputAbleViewDelegate <NSObject>

@optional

- (void)sendInputStatus;

- (void)sendStopInputStatus;

- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput sendMsg:(TSIMMsg *)msg;

// 效果参考ios微信发语间消息效果
// 即将发送msg
- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput willSendMsg:(TSIMMsg *)msg;

// 使用新消息替换原来的
- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput replaceWith:(TSIMMsg *)newMsg oldMsg:(TSIMMsg *)msg;

// 取消即将发送的
- (void)onChatInput:(UIView<TSChatInputAbleView> *)chatInput cancelSendMsg:(TSIMMsg *)msg;


@optional
- (void)onChatInputSendImage:(UIView<TSChatInputAbleView> *)chatInput;
- (void)onChatInputTakePhoto:(UIView<TSChatInputAbleView> *)chatInput;
- (void)onChatInputSendFile:(UIView<TSChatInputAbleView> *)chatInput;
- (void)onChatInputRecordVideo:(UIView<TSChatInputAbleView> *)chatInput;

@end
