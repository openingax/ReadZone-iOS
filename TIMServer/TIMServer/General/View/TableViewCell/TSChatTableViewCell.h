//
//  TSChatTableViewCell.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatBaseTableViewCell.h"
#import "MicroVideoPlayView.h"
#import "ImageTitleButton.h"

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
{
    @protected ImageTitleButton *_soundButton;
}

@end

@interface TSChatFileTableViewCell : TSChatBaseTableViewCell

@end

@interface TSChatVideoTableViewCell : TSChatBaseTableViewCell
{
    MicroVideoPlayView *_videoPanel;
}

@end
