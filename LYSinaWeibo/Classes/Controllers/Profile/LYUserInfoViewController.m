
//
//  LYUserInfoViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/30.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYUserInfoViewController.h"
#import "LYUser.h"
#import "LYUserInfoHeaderView.h"
#import "LYStatusListCell.h"
#import "LYStatusList.h"
#import "LYStatusDetailViewController.h"
#import "LYFollowUserListViewController.h"
#import "LYShareSheet.h"

@interface LYUserInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LYUserInfoHeaderView *headerView;

@property (nonatomic, strong) LYStatusList *statusList;

@end

@implementation LYUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    [self.tableView addParallaxWithView:self.headerView andHeight:self.headerView.height];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
    
    self.statusList = [LYStatusList statusListWithType:LYStatusListTypeOfOther_All];
    self.statusList.otherUid = self.currentUser.idStr;
    
    [self setupNavItem];
    
    [self refresh];
}

- (void)setupNavItem {
    //改变左上角item颜色
    UIButton *button = self.navigationItem.leftBarButtonItem.customView;
    [button setImage:[UIImage imageNamed:@"userinfo_navigationbar_back_withtext"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"userinfo_navigationbar_back_withtext_highlighted"] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"userinfo_navigationbar_search"] hightlightedImage:[UIImage imageNamed:@"userinfo_navigationbar_search_highlighted"] target:self action:@selector(search)];
    UIBarButtonItem *moreItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"userinfo_navigationbar_more"] hightlightedImage:[UIImage imageNamed:@"userinfo_navigationbar_more_highlighted"] target:self action:@selector(more)];
    
    self.navigationItem.rightBarButtonItems = @[moreItem, searchItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(LYBaseNavigationController *)self.navigationController makeNavigationBarBackgroundTransparent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [(LYBaseNavigationController *)self.navigationController recoverNavigationBarBackground];
}

- (LYUserInfoHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [LYUserInfoHeaderView headerViewWithUser:self.currentUser];
        ESWeakSelf
        _headerView.userIconClicked = ^{
            ESStrongSelf
            
        };
        _headerView.vipButtonClicked = ^{
            ESStrongSelf
            
        };
        _headerView.followButtonClicked = ^{
            ESStrongSelf
            [strongSelf friendList];
        };
        _headerView.fanButtonClicked = ^{
            ESStrongSelf
            [strongSelf followerList];
        };
        _headerView.editUserInfo = ^{
            ESStrongSelf
            [strongSelf editUserInfo];
        };
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return self.statusList.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYStatusListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusList forIndexPath:indexPath];
    cell.canLoadImage = !(tableView.isDecelerating || tableView.isDragging);
    cell.currentStatus = self.statusList.list[indexPath.section];
    ESWeakSelf
    cell.showRetweetedStatus = ^(LYStatus *status) {
        ESStrongSelf
        [strongSelf showStatus:status];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYStatus *status = self.statusList.list[indexPath.section];
    if (status.cellHeight < 10) {
        status.cellHeight = [LYStatusListCell cellHeightWithStatus:status];
    }
    return status.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showStatus:self.statusList.list[indexPath.section]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.tableView reloadData];
    }
}

#pragma mark - item action 
- (void)search {
    
}

- (void)more {
    LYShareSheet *sheet = [[LYShareSheet alloc] initWithStyle:LYShareSheetStyleUserInfo];
    [sheet show];
}

- (void)friendList {
    LYFollowUserListViewController *vc = [LYFollowUserListViewController viewControllerWithListType:LYFollowUserListTypeFriends uid:self.currentUser.idStr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)followerList {
    LYFollowUserListViewController *vc = [LYFollowUserListViewController viewControllerWithListType:LYFollowUserListTypeFollowers uid:self.currentUser.idStr];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editUserInfo {
    
}

- (void)showStatus:(LYStatus *)status {
    status.retweeted = NO;
    LYStatusDetailViewController *vc = [[LYStatusDetailViewController alloc] init];
    vc.currentStatus = status;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - data 
- (void)refresh {
    [self loadWithMore:NO];
}

- (void)refreshMore {
    [self loadWithMore:YES];
}

- (void)loadWithMore:(BOOL)more {
    if (self.statusList.loading) {
        return;
    }
    self.statusList.loading = YES;
    self.statusList.willLoadMore = more;
    
    ESWeakSelf
    [[LYNetworkTool sharedTool] requestGETWithPath:[self.statusList toInfoPath] parameters:[self.statusList toInfoParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        strongSelf.statusList.loading = NO;
        if (error) {
            [strongSelf.statusList loadFailed];
        } else {
            [strongSelf.statusList configWithData:data];
            [strongSelf.tableView reloadData];
        }
    }];
}

@end