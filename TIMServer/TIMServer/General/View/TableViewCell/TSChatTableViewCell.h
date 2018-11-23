//
//  TSChatTableViewCell.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatBaseTableViewCell.h"

@interface TSChatTextTableViewCell : TSChatBaseTableViewCell
{
@protected
    UILabel *_chatText;
}

@end

@interface TSChatImageTableViewCell : TSChatBaseTableViewCell
{
@protected
    UIImageView     *_chatImage;
}

@end

@interface TSChatSoundTableViewCell : TSChatBaseTableViewCell


@end

@interface TSChatFileTableViewCell : TSChatBaseTableViewCell

@end

@interface TSChatVideoTableViewCell : TSChatBaseTableViewCell

@end
