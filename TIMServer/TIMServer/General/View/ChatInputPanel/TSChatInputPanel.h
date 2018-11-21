//
//  TSChatInputPanel.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatInputBaseView.h"
#import "TSChatInputToolBar.h"
#import "TSChatInputAbleView.h"

@interface TSChatInputPanel : TSChatInputBaseView <TSChatInputToolBarDelegate>
{
@protected
    TSChatInputToolBar                    *_toolBar;
@protected
    __weak UIView<TSChatInputAbleView>           *_panel;
    
@protected
    UIView<TSChatInputAbleView>           *_emojPanel;
    UIView<TSChatInputAbleView>           *_funcPanel;
}

- (instancetype)initRichChatInputPanel;

- (void)setInputText:(NSString *)text;

- (TSIMMsg *)getMsgDraft;

- (void)setMsgDraft:(TSIMMsg *)draft;

@end

@interface TSRichChatInputPanel : TSChatInputPanel

@end
