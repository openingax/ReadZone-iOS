//
//  TSChatInputBaseView.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSChatInputAbleView.h"
#import "CommonLibrary.h"
#import "TSConstMarco.h"
#import "TSConstMarco.h"
#import "TSChatSoundRecorder.h"

//chat toolbar
#define CHAT_BAR_MIN_H 36
#define CHAT_BAR_MAX_H 72
#define CHAT_BAR_HORIZONTAL_PADDING 8
#define CHAT_BAR_VECTICAL_PADDING 5
#define CHAT_MORE_BTN_SIZE 50
#define CHAT_MORE_LABLE_PADDING 3
#define CHAT_MORE_LABLE_HEIGHT 14
#define CHAT_MORE_BTN_VECTICAL_PADDING 10

#define CHAT_EMOJ_COL 7     //emoj键盘的列数
#define CHAT_EMOJ_ROW 4
#define CHAT_EMOJ_SIZE 28   //emoj图像的大小
#define CHAT_EMOJ_VECTICAL_PADDING 9  //btn距离上下缘的距离
#define CHAT_MORE_VIEW_H    80
#define CHAT_EMOJ_VIEW_H    216
#define CHAT_RECORD_VIEW_H    216
#define CHAT_EMOJ_VIEW_PAGE_CNTL_H   18

@interface TSChatInputBaseView : UIView <TSChatInputAbleView>
{
@protected
    __weak id<TSChatInputAbleViewDelegate> _chatDelegate;
    
@protected
    NSInteger   _contentHeight;
    
}

@property (nonatomic, weak) id<TSChatInputAbleViewDelegate> chatDelegate;
@property (nonatomic, assign) NSInteger contentHeight;

@end
