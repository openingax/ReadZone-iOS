//
//  TSIMAPlatform+IMSDKCallBack.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/26.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSIMAPlatform.h"
#import <ImSDK/TIMCallback.h>

// IMSDK回调（除MessageListener外）统一处理

@interface TSIMAPlatform (IMSDKCallBack)<TIMUserStatusListener, TIMConnListener, TIMRefreshListener, TLSRefreshTicketListener>

@end

@interface TSIMAPlatform (FriendShipListener)<TIMFriendshipListener>

@end

@interface TSIMAPlatform (GroupAssistantListener)<TIMGroupListener>

@end
