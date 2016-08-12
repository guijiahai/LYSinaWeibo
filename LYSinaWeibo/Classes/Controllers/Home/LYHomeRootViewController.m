//
//  LYHomeRootViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYHomeRootViewController.h"
#import "LYHomeFollowView.h"
#import "LYStatusList.h"
#import "LYStatusListCell.h"
#import "LYStatusDetailViewController.h"
#import "LYNavigationTitleView.h"
#import "LYMiddlePopoverView.h"
#import "LYSidePopoverView.h"
#import "LYScanViewController.h"

@interface LYHomeRootViewController () <LYNavigationTitleViewDelegate, LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate>

@property (nonatomic, strong) LYStatusList *statusList;

//未登录
@property (nonatomic, strong) LYHomeFollowView *followView;

//已登录
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) LYNavigationTitleView *titleView;
@property (nonatomic, strong) LYMiddlePopoverView *popoverView;

@end

@implementation LYHomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (![LYLogin sharedLogin].isLogin) {
        
        self.navigationItem.leftBarButtonItem = [self itemWithTitle:@"注册" action:@selector(registerClick)];
        self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"登录" action:@selector(loginClick)];
        [self.view addSubview:self.followView];
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
//        self.navigationItem.title = [LYLogin sharedLogin].currentUser.name;
        self.navigationItem.title = @"首页";
        
        self.titleView = [[LYNavigationTitleView alloc] init];
        self.titleView.title = @"所有微博";
        self.titleView.delegate = self;
        self.navigationItem.titleView = self.titleView;
        
        
        [self.view addSubview:self.tableView];
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44.0)];
        self.tableView.tableHeaderView = self.searchBar;
        
        _statusList = [LYStatusList statusListWithType:LYStatusListTypeFriends];
        
//        [self refresh];
        
        //header
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_header = header;
        
        //footer
        MJRefreshAutoFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        self.tableView.mj_footer = footer;
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_icon_radar"] hightlightedImage:[UIImage imageNamed:@"navigationbar_icon_radar_highlighted"] target:self action:@selector(showRightPopover)];
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_friendattention"] hightlightedImage:[UIImage imageNamed:@"navigationbar_friendattention_highlighted"] target:self action:@selector(accessFriendsAttention)];
    }
}

- (void)refresh {
    if (self.statusList.isLoading) {
        return;
    }
    self.statusList.loading = YES;
    self.statusList.willLoadMore = NO;
    [self sendRequest];
}

- (void)loadMore {
    if (self.statusList.isLoading) {
        return;
    }
    self.statusList.loading = YES;
    self.statusList.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
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


- (LYHomeFollowView *)followView {
    if (!_followView) {
        _followView = [[LYHomeFollowView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - self.tabBarController.tabBar.height)];
    }
    return _followView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64 - self.tabBarController.tabBar.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LYStatusListCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusList];
    }
    return _tableView;
}

- (UIBarButtonItem *)itemWithTitle:(NSString *)title action:(nullable SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : LYMainColor} forState:UIControlStateNormal];
    return item;
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
    cell.canLoadImage = !(tableView.isDragging || tableView.isDecelerating);
    cell.currentStatus = self.statusList.list[indexPath.section];
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
    LYStatus *status = self.statusList.list[indexPath.section];
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

- (void)showStatus:(LYStatus *)status {
    if (status) {
        status.retweeted = NO;
        LYStatusDetailViewController *vc = [[LYStatusDetailViewController alloc] init];
        vc.currentStatus = status;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)registerClick {

}

- (void)loginClick {
    [self loginToOAuthController];
}


#pragma mark - LYNavigationTitleViewDelgate
- (void)navigationTitleViewDidSelectItem:(LYNavigationTitleView *)titleView {
    if (!_popoverView) {
        _popoverView = [[LYMiddlePopoverView alloc] init];
        _popoverView.dataSource = self;
        _popoverView.delegate = self;
    }
    [_popoverView show];
    [_popoverView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate

- (NSInteger)numberOfSectionsInMiddlePopoverView:(LYMiddlePopoverView *)popoverView {
    return 3;
}

- (NSArray<NSString *> *)middlePopoverView:(LYMiddlePopoverView *)popoverView titlesForSection:(NSInteger)section {
    if (section == 0) {
        return @[@"首页", @"好友圈", @"群微博"];
    } else if (section == 1) {
        return @[@"特别关注", @"本地生活", @"搞笑幽默", @"名人明星", @"同学", @"同事", @"动漫", @"新闻趣事", @"科学探索", @"搞笑", @"悄悄关注"];
    } else {
        return @[@"周边微博"];
    }
}

- (NSString *)middlePopoverView:(LYMiddlePopoverView *)popoverView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
            return @"我的分组";
        case 2:
            return @"其他";
    }
    return nil;
}

- (NSString *)titleOfBottomButtonInMiddlePopoverView:(LYMiddlePopoverView *)popoverView {
    return @"编辑我的分组";
}

- (void)middlePopoverView:(LYMiddlePopoverView *)popoverView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)bottomButtonDidSelectInMiddlePopoverView:(LYMiddlePopoverView *)popoverView {
    
}

- (void)middlePopoverViewDidDismiss:(LYMiddlePopoverView *)popoverView {
    self.titleView.selected = NO;
}

- (void)showRightPopover {
    LYSidePopoverView *popoverView = [[LYSidePopoverView alloc] initWithStyle:LYSidePopoverViewStyleRight titles:@[@"雷达", @"扫一扫"] images:@[[UIImage imageNamed:@"popover_icon_radar"], [UIImage imageNamed:@"popover_icon_qrcode"]]];
    
    ESWeakSelf
    popoverView.didSelectRowAtIndex = ^(NSInteger index) {
        ESStrongSelf
        if (index == 1) {
            LYScanViewController *vc = [[LYScanViewController alloc] init];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    [popoverView show];
}

- (void)accessFriendsAttention {
 
}

@end
