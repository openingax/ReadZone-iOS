//
//  RZMsgUserCell.h
//  ReadZone
//
//  Created by 谢立颖 on 2018/10/29.
//  Copyright © 2018 谢立颖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImSDK/TIMConversation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RZMsgUserCell : UITableViewCell

@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
