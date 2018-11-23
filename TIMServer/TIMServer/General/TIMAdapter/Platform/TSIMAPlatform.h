//
//  TSIMAPlatform.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QALSDK/QalSDKProxy.h>
#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>

// TIMServer IM 服务的业务逻辑入口，
typedef EQALNetworkType TCQALNetwork;

@interface TSIMAPlatform : NSObject

@protected
IMAHost                     *_host;             // 当前用户
IMAContactManager           *_contactMgr;       // 联系人
IMAConversationManager      *_conversationMgr;  // 会话列表

}

@end
