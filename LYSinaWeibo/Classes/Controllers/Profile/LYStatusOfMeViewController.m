//
//  LYStatusOfMeViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusOfMeViewController.h"
#import "LYNavigationTitleView.h"
#import "LYMiddlePopoverView.h"
#import "LYActionSheet.h"
#import "LYStatusListCell.h"
#import "LYStatusList.h"
#import "LYStatusDetailViewController.h"

@interface LYStatusOfMeViewController () <UITableViewDataSource, UITableViewDelegate, LYNavigationTitleViewDelegate, LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate, LYActionSheetDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray <LYStatusList *> *statusLists;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LYNavigationTitleView *titleView;
@property (nonatomic, strong) LYMiddlePopoverView *popoverView;

@end

@implementation LYStatusOfMeViewController

- (void)setupData {
    self.titles = @[@"全部微博", @"原创微博", @"图片微博"];
    self.statusLists = @[
                         [LYStatusList statusListWithType:LYStatusListTypeOfOther_All],
                         [LYStatusList statusListWithType:LYStatusListTypeOfOther_Original],
                         [LYStatusList statusListWithType:LYStatusListTypeOfOther_Picture]
                         ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    
    self.titleView = [[LYNavigationTitleView alloc] init];
    self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_more"] hightlightedImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(showMoreSheet)];

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    [self goToCategoryWithIndex:0];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = LYBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[LYStatusListCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusList];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark - table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.statusLists[self.currentIndex].list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYStatusListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusList forIndexPath:indexPath];
    cell.canLoadImage = !(tableView.isDragging || tableView.isDecelerating);
    cell.currentStatus = self.statusLists[self.currentIndex].list[indexPath.section];
    ESWeakSelf
    cell.showRetweetedStatus = ^(LYStatus *status) {
        ESStrongSelf
        [strongSelf showStatus:status];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYStatus *status = self.statusLists[self.currentIndex].list[indexPath.section];
    if (status.cellHeight < 10.0) {
        status.cellHeight = [LYStatusListCell cellHeightWithStatus:status];
    }
    return status.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showStatus:self.statusLists[self.currentIndex].list[indexPath.section]];
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
    [_popoverView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
}

#pragma mark - LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate

- (NSInteger)numberOfSectionsInMiddlePopoverView:(LYMiddlePopoverView *)popoverView {
    return 1;
}

- (NSArray<NSString *> *)middlePopoverView:(LYMiddlePopoverView *)popoverView titlesForSection:(NSInteger)section {
    return self.titles;
}

- (void)middlePopoverViewDidDismiss:(LYMiddlePopoverView *)popoverView {
    self.titleView.selected = NO;
}

- (void)middlePopoverView:(LYMiddlePopoverView *)popoverView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goToCategoryWithIndex:indexPath.row];
}

#pragma mark - show status

- (void)showStatus:(LYStatus *)status {
    status.retweeted = NO;
    LYStatusDetailViewController *vc = [[LYStatusDetailViewController alloc] init];
    vc.currentStatus = status;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToCategoryWithIndex:(NSInteger)index {
    self.titleView.title = self.titles[index];
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    self.currentIndex = index;
    [self.tableView reloadData];
    
    LYStatusList *statusList = self.statusLists[self.currentIndex];
    if (statusList.list == nil) {
        [self.tableView.mj_header beginRefreshing];
    } else if (statusList.list.count == 0) {
        [self.view configWithType:EaseBlankPageTypeDefault blank:YES error:statusList.isLoadFailed reloadBlock:nil];
    } else if (statusList.canLoadMore) {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer setHidden:NO];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        [self.tableView.mj_footer setHidden:YES];
    }
}

- (void)refresh {
    [self loadWithMore:NO];
}

- (void)loadMore {
    [self loadWithMore:YES];
}

- (void)loadWithMore:(BOOL)more {
    LYStatusList *statusList = self.statusLists[self.currentIndex];
    if (statusList.isLoading) {
        return;
    }
    statusList.loading = YES;
    statusList.willLoadMore = more;
    
    ESWeakSelf
    
    [[LYNetworkTool sharedTool] requestGETWithPath:[statusList toInfoPath] parameters:[statusList toInfoParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        statusList.loading = NO;
        if (error) {
            [statusList loadFailed];
        } else {
            [statusList configWithData:data];
        }
        NSInteger index = [strongSelf.statusLists indexOfObject:statusList];
        if (index == strongSelf.currentIndex) {
            [strongSelf.tableView.mj_header endRefreshing];
            [strongSelf.tableView.mj_footer endRefreshing];
            if (!error) {
                [strongSelf.tableView reloadData];
            }
            [strongSelf.view configWithType:EaseBlankPageTypeDefault blank:statusList.list.count <= 0 error:statusList.isLoadFailed reloadBlock:nil];
        }
    }];
}

- (void)showMoreSheet {
    LYActionSheet *sheet = [[LYActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"刷新", @"返回首页", nil];
    [sheet show];
}

- (void)actionSheet:(LYActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    } else if (buttonIndex == 1) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

@end
