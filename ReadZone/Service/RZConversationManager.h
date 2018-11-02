//
//  RZConversationManager.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/11/1.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZConversation.h"
#import "RZSafeMutableArray.h"
#import "RZIMUser.h"

#import <ImSDK/ImSDK.h>

typedef NS_ENUM(NSUInteger, RZConversationChangedNotifyType) {
    RZConversationChangedNotifyTypeSyncLocalConversation    = 0x01,         // 同步本地会话结束
    RZConversationChangedNotifyTypeBecomeActiveTop          = 0x01 << 1,    // 当前会话放在会话列表顶部
    RZConversationChangedNotifyTypeNewConversation          = 0x01 << 2,    // 新增会话
    RZConversationChangedNotifyTypeDeleteConversation       = 0x01 << 3,    // 删除会话
    RZConversationChangedNotifyTypeConnected                = 0x01 << 4,    // 网络连上
    RZConversationChangedNotifyTypeDisConnected             = 0x01 << 5,    // 网络断开
    RZConversationChangedNotifyTypeConversationChanged      = 0x01 << 6,    // 会话有更新
    
    RZConversationChangedNotifyTypeAllEvents                = RZConversationChangedNotifyTypeSyncLocalConversation | RZConversationChangedNotifyTypeBecomeActiveTop | RZConversationChangedNotifyTypeNewConversation | RZConversationChangedNotifyTypeDeleteConversation | RZConversationChangedNotifyTypeConnected | RZConversationChangedNotifyTypeDisConnected | RZConversationChangedNotifyTypeConversationChanged,
};

@interface RZConversationChangedNotifyItem : NSObject

@property(nonatomic,assign) RZConversationChangedNotifyType type;
@property(nonatomic,assign) RZConversation *conversation;
@property(nonatomic,assign) NSInteger index;
@property(nonatomic,assign) NSInteger toIndex;

- (instancetype)initWithType:(RZConversationChangedNotifyType)type;
- (NSString *)notificaionName;
- (NSNotification *)changedNotification;

@end



typedef void(^RZConversationChangedCompletion)(RZConversationChangedNotifyItem *item);

@interface RZConversationManager : NSObject <TIMMessageListener>
{
@protected
    RZSafeMutableArray      *_conversationList;
    NSInteger               _refreshStyle;
    RZConversation          *_chattingConversation;                         // 正在聊天
}

@property(nonatomic,readonly) RZSafeMutableArray *conversationList;
@property(nonatomic,assign) NSUInteger unReadMsgCount;
@property(nonatomic,copy) RZConversationChangedCompletion conversationChangedCompletion;

- (void)releaseChattingConversation;
- (void)deleteConversation:(RZConversation *)conv needUIRefresh:(BOOL)need;
- (void)asyncRefreshConversationList;

- (RZConversation *)chatWith:(RZIMUser *)user;
- (RZConversation *)queryConversationWithUser:(RZIMUser *)user;
- (void)removeConversationWithUser:(RZIMUser *)user;
- (void)updateConversationWithUser:(RZIMUser *)user;

@end
