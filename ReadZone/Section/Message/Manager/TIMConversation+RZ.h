//
//  TIMConversation+RZ.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <ImSDK/ImSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TIMConversation (RZ)

@property(nonatomic,copy) NSString *identifier;
@property(nonatomic,copy) NSString *faceURL;
@property(nonatomic,copy) NSString *nickName;

@end

NS_ASSUME_NONNULL_END
