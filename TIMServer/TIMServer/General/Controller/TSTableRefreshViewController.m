//
//  TSTableRefreshViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/11/21.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSTableRefreshViewController.h"

@implementation RequestPageParamItem

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 0;
        _pageSize = 20;
        _canLoadMore = YES;
    }
    return self;
}

@end

@interface TSTableRefreshViewController ()

@end

@implementation TSTableRefreshViewController

- (void)initialize
{
    [super initialize];
    _clearsSelectionOnViewWillAppear = YES;
    _pageItem = [[RequestPageParamItem alloc] init];
}

- (void)addHeaderView
{
    self.headerView = [[HeadRefreshView alloc] init];
}

- (void)pinHeaderAndRefesh
{
    [self pinHeaderView];
    [self refresh];
}

- (void)addFooterView
{
//    self.footerView = [[TSFootRefreshView alloc] init];
}

- (void)addRefreshScrollView
{
    _tableView = [[UITableView alloc] init];
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = kClearColor;
    _tableView.scrollsToTop = YES;
    [self.view addSubview:_tableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.refreshScrollView = _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_tableView) {
        
        // 取消选中态
        NSIndexPath *selectedIdx = [_tableView indexPathForSelectedRow];
        if (selectedIdx) {
            [_tableView deselectRowAtIndexPath:selectedIdx animated:animated];
        }
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)hasData
{
    BOOL has = _datas.count != 0;
    _tableView.separatorStyle = has ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
    return has;
}

- (BOOL)needFollowScrollView {
    return NO;
}

- (void)relaodData {
    [_tableView reloadData];
    [self allLoadingCompleted];
}

- (void)showNoDataView
{
    
}

- (void)allLoadingCompleted
{
    [super allLoadingCompleted];
    
    BOOL has = [self hasData];
    _noDataView.hidden = has;
    if (!has)
    {
        [self showNoDataView];
    }
}

@end
