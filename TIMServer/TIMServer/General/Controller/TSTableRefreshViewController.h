//
//  TSTableRefreshViewController.h
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSScrollRefreshViewController.h"

@interface RequestPageParamItem : NSObject

@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,assign) NSInteger pageSize;
@property(nonatomic,assign) BOOL canLoadMore;

@end

@interface TSTableRefreshViewController : TSScrollRefreshViewController <UITableViewDelegate, UITableViewDataSource>
{
@protected
    UITableView                 *_tableView;
    NSMutableArray              *_datas;
@protected
    RequestPageParamItem        *_pageItem;
}

@property(nonatomic,strong) UITableView *tableView;

// Defaults to YES
@property(nonatomic,assign) BOOL clearsSelectionOnViewWillAppear;

// 代码下拉刷新
- (void)pinHeaderAndRefesh;

@end

