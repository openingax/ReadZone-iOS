//
//  TIMUserProfile+RZ.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <ImSDK/ImSDK.h>

NS_ASSUME_NONNULL_BEGIN

@class TIMConversation;

@interface TIMUserProfile (RZ)

@property(nonatomic,strong) TIMConversation *conversation;

@end

NS_ASSUME_NONNULL_END
