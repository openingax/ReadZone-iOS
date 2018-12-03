//
//  TSChatViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/6.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSChatViewController.h"
#import "TSInputToolBar.h"
#import "TSConstMarco.h"
#import "UIView+CustomAutoLayout.h"
#import "UIView+Toast.h"
#import "TSConversation.h"
#import "TSConversationManager.h"
#import "TIMServerHelper.h"
#import "TSColorMarco.h"
#import <Masonry/Masonry.h>
#import "TSIMAPlatform.h"
#import "TSImageThumbPickerViewController.h"
//#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>

// 照片选择器
#import "TZImagePickerController.h"
#import "TZPhotoPreviewController.h"
#import "TZVideoPlayerController.h"
#import "TZImageManager.h"

// UGC 小视频
#import "TCVideoRecordViewController.h"
#import "TCNavigationController.h"
//#import "TCVideoPreviewViewController.h"

@interface TSChatViewController () <TSInputToolBarDelegate, TZImagePickerControllerDelegate, MicroVideoRecordDelegate>
{
    NSMutableArray *_selectedPhotos;
    BOOL isSelectedOriginalPhoto;
    
    UIView *_videoRecordView;
}

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property(nonatomic,assign) NSInteger refreshIndex;

@end

@implementation TSChatViewController

- (instancetype)initWithUser:(TSIMUser *)user {
    if (self = [super init]) {
        _receiver = user;
        self.refreshIndex = 0;
    }
    return self;
}

- (void)configWithUser:(TSIMUser *)user {
    
    [_receiverKVO unobserveAll];
    
    _receiver = user;
    
    [self setChatTitle];
    
    if (_conversation) {
        [_conversation releaseConversation];
        _messageList = nil;
        [self reloadData];
    }
}

- (void)didLogin {
    
    __weak TSChatViewController *ws = self;
    [[TSIMAPlatform sharedInstance].conversationMgr asyncConversationList];
    self.conversation.receiveMsg = ^(NSArray *imMsgList, BOOL succ) {
        __strong TSChatViewController *ss = ws;
        [ss onReceiveNewMsg:imMsgList succ:succ];
        [ss updateMessageList];
    };
}

- (void)conversationListUpdateComplete {
    
    if (self.refreshIndex == 1) return;
    
    __weak TSChatViewController *ws = self;
    
    _conversation = [[TSIMAPlatform sharedInstance].conversationMgr chatWith:_receiver];
    _messageList = _conversation.msgList;
    
    [_conversation asyncLoadRecentMessage:10 completion:^(NSArray *imMsgList, BOOL succ) {
        [ws onLoadRecentMessage:imMsgList complete:succ scrollToBottom:YES];
        ws.refreshIndex ++;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configWithUser:_receiver];
    
    self.view.backgroundColor = kWhiteColor;
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
    [self.tableView addGestureRecognizer:tapAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversationListUpdateComplete) name:kAsyncUpdateConversationListNoti object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [_receiverKVO unobserveAll];
    _conversation.receiveMsg = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiddenKeyBoard {
    
}

- (void)setChatTitle {
    self.title = TIMLocalizedString(@"MSG_NAV_TITLE", @"留言板");
}


#pragma mark - Add View
- (void)addHeaderView {
    // 添加头部视图
    self.headerView = [[ChatHeadRefreshView alloc] init];
}

- (void)onRefresh {
    
    __weak typeof(self) weakSelf = self;
    [_conversation asyncLoadRecentMessage:10 completion:^(NSArray *imMsgList, BOOL succ) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (succ) {
            [self onLoadRecentMessage:imMsgList complete:YES scrollToBottom:YES];
        }
        
        [strongSelf refreshCompleted];
        [strongSelf layoutHeaderRefreshView];
    }];
}

- (void)addOwnViews {
    [super addOwnViews];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0.f;
    
    [self addChatToolBar];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    longPressGr.minimumPressDuration = 1.0;
    [_tableView addGestureRecognizer:longPressGr];
}

- (void)addChatToolBar {
    
}

- (void)layoutRefreshScrollView {
    
    CGFloat kToolbarY = CGRectGetMaxY(self.view.bounds) - CHAT_BAR_MIN_H - 2*CHAT_BAR_VECTICAL_PADDING;
    // do nothing
    _tableView.frame = CGRectMake(CGRectGetMinX(self.view.bounds), CGRectGetMinY(self.view.bounds), CGRectGetWidth(self.view.bounds), kToolbarY);
}

-(void)onLongPress:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        UITableViewCell<TSElemAbleCell> *cell = [_tableView cellForRowAtIndexPath:indexPath];
        BOOL showMenu = [cell canShowMenu];
        
        if (showMenu)
        {
            if ([cell canShowMenuOnTouchOf:gesture])
            {
                [cell showMenu];
            }
        }
    }
}

- (void)sendMsg:(TSIMMsg *)msg
{
    if (msg)
    {
        //        _isSendMsg = YES;
        [_tableView beginUpdates];
        
        __weak TSChatViewController *ws = self;
        DebugLog(@"will sendmessage");
        
        __weak typeof(self) weakSelf = self;
        NSArray *newaddMsgs = [_conversation sendMessage:msg completion:^(NSArray *imamsglist, BOOL succ, int code) {
            
            __weak typeof(weakSelf) strongnSelf = weakSelf;
            
            DebugLog(@"sendmessage end");
            [ws updateOnSendMessage:imamsglist succ:succ];
            
            if (!succ)
            {
                if (code == 80001)
                {
                    TSIMMsg *msg = [TSIMMsg msgWithCustom:TSIMMsgTypeSaftyTip];
                    [strongnSelf.messageList addObject:msg];
                    
                    [strongnSelf showMsgs:@[msg]];
                } else if (code == 6004) {
                    [strongnSelf.view makeToast:@"登录已过期"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongnSelf dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }
        }];
        
        [self showMsgs:newaddMsgs];
    }
}

- (void)sendImage:(UIImage *)image orignal:(BOOL)orignal
{
    if (image)
    {
        TSIMMsg *msg = [TSIMMsg msgWithImage:image isOriginal:orignal];
        [self sendMsg:msg];
    }
}

- (void)sendImages:(NSArray<UIImage*>*)images original:(BOOL)original {
    if (images.count == 1) {
        [self sendImage:[images firstObject] orignal:original];
    } else {
        TSIMMsg *msg = [TSIMMsg msgWithImages:images isOriginal:original];
        [self sendMsg:msg];
    }
}

- (void)sendVideoWithPath:(NSString *)path coverImage:(UIImage *)image {
    if (!path || !image) {
        NSLog(@"视频文件不合法");
        return;
    }
    TSIMMsg *msg = [TSIMMsg msgWithVideoPath:path];
    [self sendMsg:msg];
}

- (void)onReceiveNewMsg:(NSArray *)imamsgList succ:(BOOL)succ
{
    [_tableView beginUpdates];
    
    NSInteger count = [imamsgList count];
    NSMutableArray *indexArray = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++)
    {
        NSInteger idx = _messageList.count + i - count;
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [indexArray addObject:index];
    }
    
    [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    [_tableView endUpdates];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateOnSendMessage:imamsgList succ:YES];
    });
}

//当消息量过大时，需要清理部分消息，避免内存持续增长
- (void)updateMessageList
{
    if (_messageList.count > 1000)
    {
        DebugLog(@"_messageList.count > 1000");
        int rangLength = 100;
        NSRange range = NSMakeRange(_messageList.count-rangLength, rangLength);
        [_messageList subArrayWithRange:range];
        [_tableView reloadData];
    }
}

- (void)showMsgs:(NSArray *)msgs
{
    NSMutableArray *array = [NSMutableArray array];
    for (TSIMMsg *msg in msgs)
    {
        NSInteger idx = [_messageList indexOfObject:msg];
        NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
        [array addObject:index];
    }
    
#warning Terminating app due to uncaught exception 'NSInternalInconsistencyException'
    /*
     Invalid update: invalid number of rows in section 0.  The number of rows contained in an existing section after the update (17) must be equal to the number of rows contained in that section before the update (13), plus or minus the number of rows inserted or deleted from that section (1 inserted, 0 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).
     */
    
    @try {
        [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationBottom];
        [_tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:self->_messageList.count - 1 inSection:0];
            [self->_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    } @catch (NSException *exception) {
        NSLog(@"!!!!!!!!!!!\ninvalid number of rows in section: %@\n!!!!!!!!!!", exception);
    } @finally {
        
    }
    
}

- (void)sendText:(NSString *)text
{
    if (text && text.length > 0)
    {
        TSIMMsg *msg = [TSIMMsg msgWithText:text];
        [self sendMsg:msg];
    }
}

- (void)didChangeToolBarHight:(CGFloat)toHeight
{
    __weak TSChatViewController* weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = weakself.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = weakself.view.frame.size.height - toHeight;
        weakself.tableView.frame = rect;
    }];
    
    if (_tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSIMMsg *msg = [_messageList objectAtIndex:indexPath.row];
    return [msg heightInWidth:tableView.bounds.size.width inStyle:_conversation.type == TIM_GROUP];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSIMMsg *msg = [_messageList objectAtIndex:indexPath.row];
    
    UITableViewCell<TSElemAbleCell> *cell = [msg tableView:tableView style:[_receiver isC2CType] ? TSElemCellStyleC2C : TSElemCellStyleGroup indexPath:indexPath];
    [cell configWith:msg];
    return cell;
}

#pragma mark -

- (void)toolBar:(TSInputToolBar *)toolBar didClickSendButton:(NSString *)content {
    
}

#pragma mark - Load Message
- (void)onLoadRecentMessage:(NSArray *)imamsgList complete:(BOOL)succ scrollToBottom:(BOOL)scroll
{
    if (succ)
    {
        if (imamsgList.count > 0)
        {
            [_tableView beginUpdates];
            
            NSMutableArray *ar = [NSMutableArray array];
            for (NSInteger i = 0; i < imamsgList.count; i++)
            {
                [ar addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            }
            
            [_tableView insertRowsAtIndexPaths:ar withRowAnimation:UITableViewRowAnimationTop];
            
            [_tableView endUpdates];
            
            if (scroll)
            {
                __weak TSChatViewController *ws = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSIndexPath *last = [NSIndexPath indexPathForRow:imamsgList.count-1 inSection:0];
                        [self.tableView scrollToRowAtIndexPath:last atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                });
            }
        }
    }
}

- (void)updateOnSendMessage:(NSArray *)msglist succ:(BOOL)succ
{
    if (msglist.count)
    {
        NSInteger index = [_messageList indexOfObject:msglist.lastObject];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}


#pragma mark - PhotoAction
- (void)moreViewPhotoAction {
    [self hiddenKeyBoard];
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    imagePicker.isSelectOriginalPhoto = YES;
    imagePicker.allowTakePicture = YES;
    imagePicker.allowTakeVideo = NO;
    //    imagePicker.videoMaximumDuration = 20;
    [imagePicker setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    imagePicker.iconThemeColor = RGB(31, 185, 34);
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePicker setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:RGBOF(0x00A3B4) forState:UIControlStateNormal];
    }];
    
    imagePicker.allowPickingImage = YES;
    imagePicker.allowPickingVideo = YES;
    imagePicker.allowPickingOriginalPhoto = YES;
    imagePicker.allowPickingMultipleVideo = NO;
    imagePicker.sortAscendingByModificationDate = NO;
    
    imagePicker.showSelectBtn = YES;
    imagePicker.allowCrop = NO;
    imagePicker.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePicker.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    imagePicker.statusBarStyle = UIStatusBarStyleLightContent;
    imagePicker.showSelectedIndex = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    if (isSelectOriginalPhoto) {
        // 发送原图
        for (id item in assets) {
            if ([item isKindOfClass:[PHAsset class]]) {
                PHAsset *asset = (PHAsset *)item;
                
                __weak TSChatViewController *ws = self;
                [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
                    BOOL isThumbImg = [info[PHImageResultIsDegradedKey] boolValue];
                    if (!isThumbImg) {
                        [ws sendImage:photo orignal:YES];
                    }
                }];
            }
        }
        
    } else {
        // 发送普通图片
        for (UIImage *img in photos) {
            NSData *data = UIImagePNGRepresentation(img);
            
            if (data.length > 28*1024*1024) {
                [self.view makeToast:@"发送的图片过大"];
                return;
            }
            
            [self sendImage:img orignal:YES];
        }
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    
    __weak TSChatViewController *ws = self;
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPresetHighestQuality success:^(NSString *outputPath) {
        [ws sendVideoWithPath:outputPath coverImage:coverImage];
    } failure:^(NSString *errorMessage, NSError *error) {
        [self alertWithTitle:@"视频导出失败" message:@"请尝试用小视频录制喔" confirmBlock:nil];
    }];
}

#pragma mark - MovieAction
- (void)moreVideVideoAction {
    TCVideoRecordViewController *videoRecordVC = [[TCVideoRecordViewController alloc] init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:videoRecordVC];
    videoRecordVC.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)recordVideoPath:(NSString *)path
{
    NSError *err = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSDataReadingMappedIfSafe error:&err];
    //文件最大不超过28MB
    if(data.length < 28 * 1024 * 1024)
    {
        TSIMMsg *msg = [TSIMMsg msgWithVideoPath:path];
        [self sendMsg:msg];
    }
    else
    {
        [self alertWithTitle:@"提示" message:@"发送的文件过大" confirmBlock:nil];
    }
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)msg confirmBlock:(void(^)(void))block {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    
    UIAlertController *controller = [[UIAlertController alloc] init];
    controller.title = title;
    controller.message = msg;
    [controller addAction:action];
    
    [self presentViewController:controller animated:NO completion:nil];
}

@end
