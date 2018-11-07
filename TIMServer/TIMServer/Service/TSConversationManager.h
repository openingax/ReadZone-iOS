//
//  TSConversationManager.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/7.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSConversation.h"
#import "TSSafeMutableArray.h"
#import "TSIMUser.h"
#import <ImSDK/ImSDK.h>

typedef NS_ENUM(NSUInteger, TSConversationChangedNotifyType) {
    TSConversationChangedNotifyTypeSyncLocalConversation    = 0x01,         // 同步本地会话结束
    TSConversationChangedNotifyTypeBecomeActiveTop          = 0x01 << 1,    // 当前会话放在会话列表顶部
    TSConversationChangedNotifyTypeNewConversation          = 0x01 << 2,    // 新增会话
    TSConversationChangedNotifyTypeDeleteConversation       = 0x01 << 3,    // 删除会话
    TSConversationChangedNotifyTypeConnected                = 0x01 << 4,    // 网络连上
    TSConversationChangedNotifyTypeDisConnected             = 0x01 << 5,    // 网络断开
    TSConversationChangedNotifyTypeConversationChanged      = 0x01 << 6,    // 会话有更新
    
    TSConversationChangedNotifyTypeAllEvents                = TSConversationChangedNotifyTypeSyncLocalConversation | TSConversationChangedNotifyTypeBecomeActiveTop | TSConversationChangedNotifyTypeNewConversation | TSConversationChangedNotifyTypeDeleteConversation | TSConversationChangedNotifyTypeConnected | TSConversationChangedNotifyTypeDisConnected | TSConversationChangedNotifyTypeConversationChanged,
};

@interface TSConversationChangedNotifyItem : NSObject

@property(nonatomic,assign) TSConversationChangedNotifyType type;
@property(nonatomic,assign) TSConversation *conversation;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) NSInteger toIndex;

- (instancetype)initWithType:(TSConversationChangedNotifyType)type;
- (NSString *)notificaionName;
- (NSNotification *)changedNotification;

@end

typedef void(^TSConversationChangedCompletion)(TSConversationChangedNotifyItem *item);

@interface TSConversationManager : NSObject <TIMMessageListener>
{
@protected
    TSSafeMutableArray      *_conversationList;
    NSInteger               _refreshStyle;
    TSConversation          *_chattingConversation;                         // 正在聊天
}

@property(nonatomic,readonly) TSSafeMutableArray *conversationList;
@property(nonatomic,assign) NSUInteger unReadMsgCount;
@property(nonatomic,copy) TSConversationChangedCompletion conversationChangedCompletion;

- (void)releaseChattingConversation;
- (void)deleteConversation:(TSConversation *)conv needUIRefresh:(BOOL)need;
- (void)asyncRefreshConversationList;

- (TSConversation *)chatWith:(TSIMUser *)user;
- (TSConversation *)queryConversationWithUser:(TSIMUser *)user;
- (void)removeConversationWithUser:(TSIMUser *)user;
- (void)updateConversationWithUser:(TSIMUser *)user;

@end
