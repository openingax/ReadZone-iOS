//
//  TSChatTextView.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/22.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonLibrary.h"
#import "TSIMMsg.h"
#import "TSIMMsg+UITableViewCell.h"

@interface TSChatTextView : UITextView
{
    @private
    __weak TSIMMsg *_msgRef;
}

- (void)clearAll;
- (void)showMessage:(TSIMMsg*)msg;

// for overwrite
- (void)onTapImage:(UITapGestureRecognizer *)tap;

@end
