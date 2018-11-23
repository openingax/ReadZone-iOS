//
//  TSElemBaseTableViewCell.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/23.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSElemAbleCell.h"
#import "TSIMMsg.h"
#import "CommonLibrary.h"
#import "TSIMMsg+UITableViewCell.h"

@interface TSElemBaseTableViewCell : UITableViewCell <TSElemAbleCell>
{
@protected
    UIButton                                *_icon;             // 用户头像
    
@protected
    UILabel                                 *_remarkTip;        // 用户remark，群消息的时候有用
    
@protected
    UIImageView                             *_contentBack;      // 聊天内容气泡
    UIView                                  *_elemContentRef;   // 实际聊天内容显示控件
    
@protected
    UIView<TSElemSendingAbleView>            *_sendingTipRef;    // 发送提示
    
@protected
    
    UIView<TSElemPickedAbleView>           *_pickedViewRef;    // 选中按钮
@protected
    TSElemCellStyle                         _cellStyle;         // 样式
    __weak TSIMMsg                           *_msg;              // 要显示的消息弱引用
    
@protected
    FBKVOController                         *_msgKVO;           // 消息的KVO，主要是监听消息的发送状态
}
@property (nonatomic, weak) TSIMMsg *msg;

+ (UIFont *)defaultNameFont;
+ (UIFont *)defaultTextFont;

- (instancetype)initWithC2CReuseIdentifier:(NSString *)reuseIdentifier;
- (instancetype)initWithGroupReuseIdentifier:(NSString *)reuseIdentifier;

// 配置消息显示
- (void)configWith:(TSIMMsg *)msg;

// 以下方法均求子类重写
// 更新KVO监听
- (void)configKVO;

// 添加C2C样式下的控件
- (void)addC2CCellViews;

// 添加群样式下的控件
- (void)addGroupCellViews;

// 只创建，外部统一添加
- (UIView *)addElemContent;

// 子类重写，只创建，外部重写不作添加到_contentBack，内部逻辑统一添加
- (UIView<TSElemSendingAbleView> *)addSendingTips;

// 子类重写，只创建，外部重写不作添加到_contentBack，内部逻辑统一添加
- (UIView<TSElemPickedAbleView> *)addPickedView;

// 布局C2C显示的样式
- (void)relayoutC2CCellViews;

// 布局群聊天显示样式
- (void)relayoutGroupCellViews;
//
- (void)configContent;
- (void)configElemContent;
- (void)configSendingTips;

@end
