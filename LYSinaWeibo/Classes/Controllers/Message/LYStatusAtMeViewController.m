//
//  LYStatusAtMeViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/17.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusAtMeViewController.h"
#import "LYStatusAtMeCell.h"
#import "LYMiddlePopoverView.h"
#import "LYNavigationTitleView.h"
#import "LYStatusList.h"
#import "LYCommentList.h"
#import "LYStatusDetailViewController.h"
#import "LYStatusAtMeSettingViewController.h"

@interface LYStatusAtMeViewController () <LYNavigationTitleViewDelegate, LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSIndexPath *currentIndexPath;    //当前页面显示的信息

@property (nonatomic, strong) NSArray <NSArray *> *titles;

@property (nonatomic, strong) LYMiddlePopoverView *popoverView;
@property (nonatomic, strong) LYNavigationTitleView *titleView;

@property (nonatomic, strong) NSArray <LYStatusList *> *statusLists;
@property (nonatomic, strong) NSArray <LYCommentList *> *commentLists;

@end

@implementation LYStatusAtMeViewController

- (void)setupData {
    
    _titles = @[
                @[@"所有微博", @"关注人的微博", @"原创微博"],
                @[@"所有评论", @"关注人的评论"]
                ];
    
    if (!_statusLists) {
        _statusLists = @[
                         [LYStatusList statusListWithType:LYStatusListTypeAtMe_All],
                         [LYStatusList statusListWithType:LYStatusListTypeAtMe_Friends],
                         [LYStatusList statusListWithType:LYStatusListTypeAtMe_Original]
                         ];
    }
    if (!_commentLists) {
        _commentLists = @[
                          [LYCommentList commentListWithType:LYCommentListTypeAtMe_All],
                          [LYCommentList commentListWithType:LYCommentListTypeAtMe_Friends]
                          ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    
    self.titleView = [[LYNavigationTitleView alloc] init];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem defaultNormalItemWithTitle:@"设置" target:self action:@selector(setting)];

    self.tableView = ({
        UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tbView.dataSource = self;
        tbView.delegate = self;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tbView registerClass:[LYStatusAtMeCell class] forCellReuseIdentifier:kCellIdentifier_StatusAtMe];
        [self.view addSubview:tbView];
        [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tbView;
    });
    
    //header
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    //footer
    MJRefreshAutoFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer = footer;
    
    [self goToCategoryWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.currentIndexPath.section) {
        case 0:
            return self.statusLists[self.currentIndexPath.row].list.count;
        case 1:
            return self.commentLists[self.currentIndexPath.row].list.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.currentIndexPath.section) {
        case 0:
        {
            LYStatusAtMeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_StatusAtMe forIndexPath:indexPath];
            cell.canLoadImage = !(tableView.isDecelerating || tableView.isDragging);
            cell.currentStatus = self.statusLists[self.currentIndexPath.row].list[indexPath.section];
            ESWeakSelf
            cell.showRetweetedStatus = ^(LYStatus *status) {
                ESStrongSelf
                [strongSelf showStatus:status];
            };
            return cell;
        }
            break;
        case 1:
        {
            
        }
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.currentIndexPath.section) {
        case 0:
        {
            LYStatus *status = self.statusLists[self.currentIndexPath.row].list[indexPath.section];
            if (status.cellHeight < 10.0) {
                status.cellHeight = [LYStatusAtMeCell cellHeightWithStatus:status];
            }
            return status.cellHeight;
        }
        case 1:
        {
            
        }
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (self.currentIndexPath.section) {
        case 0:
        {
            [self showStatus:self.statusLists[self.currentIndexPath.row].list[indexPath.section]];
        }
            break;
        case 1:
            
            break;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.tableView reloadData];
    }
}

#pragma mark - LYNavigationTitleViewDelegate
- (void)navigationTitleViewDidSelectItem:(LYNavigationTitleView *)titleView {
    if (!_popoverView) {
        _popoverView = [[LYMiddlePopoverView alloc] init];
        _popoverView.dataSource = self;
        _popoverView.delegate = self;
    }
    [_popoverView show];
    [_popoverView selectRowAtIndexPath:self.currentIndexPath];
}

#pragma mark - LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate
- (NSInteger)numberOfSectionsInMiddlePopoverView:(LYMiddlePopoverView *)popoverView {
    return 2;
}

- (NSArray<NSString *> *)middlePopoverView:(LYMiddlePopoverView *)popoverView titlesForSection:(NSInteger)section {
    return self.titles[section];
}

- (NSString *)middlePopoverView:(LYMiddlePopoverView *)popoverView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        return @"@到我的评论";
    }
}

- (void)middlePopoverViewDidDismiss:(LYMiddlePopoverView *)popoverView {
    self.titleView.selected = NO;
}

- (void)middlePopoverView:(LYMiddlePopoverView *)popoverView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goToCategoryWithIndexPath:indexPath];
}

#pragma mark - show status
- (void)showStatus:(LYStatus *)status {
    status.retweeted = NO;
    LYStatusDetailViewController *vc = [[LYStatusDetailViewController alloc] init];
    vc.currentStatus = status;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setting {
    LYStatusAtMeSettingViewController *vc = [[LYStatusAtMeSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - load data

- (void)goToCategoryWithIndexPath:(NSIndexPath *)indexPath {
    
    self.titleView.title = self.titles[indexPath.section][indexPath.row];
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    self.currentIndexPath = indexPath;
    
    [self.tableView reloadData];
    
    switch (self.currentIndexPath.section) {
        case 0:
        {
            LYStatusList *statusList = self.statusLists[self.currentIndexPath.row];
            if (statusList.list == nil) {   //第一次
                [self.tableView.mj_header beginRefreshing];
            } else if (statusList.list.count == 0) {
                [self.view configWithType:EaseBlankPageTypeStatusAtMe blank:YES error:statusList.isLoadFailed reloadBlock:nil];
            } else if (statusList.canLoadMore) {
                [self.tableView.mj_footer resetNoMoreData];
                [self.tableView.mj_footer setHidden:NO];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer setHidden:YES];
            }
        }
            break;
        case 1:
        {
            LYCommentList *commentList = self.commentLists[self.currentIndexPath.row];
            if (commentList.list == nil) {   //第一次
                [self.tableView.mj_header beginRefreshing];
            } else if (commentList.list.count == 0) {
                [self.view configWithType:EaseBlankPageTypeStatusAtMe blank:YES error:commentList.isLoadFailed reloadBlock:nil];
            } else if (commentList.canLoadMore) {
                [self.tableView.mj_footer resetNoMoreData];
                [self.tableView.mj_footer setHidden:NO];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer setHidden:YES];
            }
        }
            break;
    }
}

- (void)refresh {
    [self loadWithMore:NO];
}

- (void)loadMore {
    [self loadWithMore:YES];
}

- (void)loadWithMore:(BOOL)more {
    switch (self.currentIndexPath.section) {
        case 0:
        {
            LYStatusList *statusList = self.statusLists[self.currentIndexPath.row];
            if (statusList.isLoading) {
                return;
            }
            statusList.loading = YES;
            statusList.willLoadMore = more;
            [self sendRequestWithIndexPath:self.currentIndexPath];
        }
            break;
        case 1:
        {
            LYCommentList *commentList = self.commentLists[self.currentIndexPath.row];
            if (commentList.isLoading) {
                return;
            }
            commentList.loading = YES;
            commentList.willLoadMore = more;
            [self sendRequestWithIndexPath:self.currentIndexPath];
        }
            break;
    }
}

- (void)sendRequestWithIndexPath:(NSIndexPath *)indexPath {
    NSString *path = nil;
    NSDictionary *params = nil;
    
    LYStatusList *statusList = nil;
    LYCommentList *commentList = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            statusList = self.statusLists[indexPath.row];
            path = [statusList toInfoPath];
            params = [statusList toInfoParams];
        }
            break;
        case 1:
        {
            commentList = self.commentLists[indexPath.row];
            path = [commentList toSearchPath];
            params = [commentList toSearchParams];
        }
            break;
    }
    if (path && params) {
        ESWeakSelf
        
        [[LYNetworkTool sharedTool] requestGETWithPath:path parameters:params andBlock:^(id data, NSError *error) {
            ESStrongSelf
            
            if (error) {
                if (statusList) {
                    [statusList loadFailed];
                    statusList.loading = NO;
                }
                if (commentList) {
                    [commentList loadFailed];
                    commentList.loading = NO;
                }
                if ([strongSelf.currentIndexPath isEqual:indexPath]) {
                    [strongSelf.tableView.mj_header endRefreshing];
                    [strongSelf.tableView.mj_footer endRefreshing];
                }
                
            } else {
                
                if (statusList) {
                    [statusList configWithData:data];
                    statusList.loading = NO;
                }
                if (commentList) {
                    [commentList configWithData:data];
                    commentList.loading = NO;
                }
                if ([strongSelf.currentIndexPath isEqual:indexPath]) {
                    [strongSelf.tableView.mj_header endRefreshing];
                    [strongSelf.tableView.mj_footer endRefreshing];
                    [strongSelf.tableView reloadData];
                }
            }
            
            if (statusList) {
                [strongSelf.view configWithType:EaseBlankPageTypeStatusAtMe blank:statusList.list.count <= 0 error:statusList.isLoadFailed reloadBlock:nil];
            }
            if (commentList) {
                [strongSelf.view configWithType:EaseBlankPageTypeStatusAtMe blank:commentList.list.count <= 0 error:commentList.isLoadFailed reloadBlock:nil];
            }
            
        }];
    }
}

@end
