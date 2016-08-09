//
//  LYFollowUserListViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/30.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYFollowUserListViewController.h"
#import "LYActionSheet.h"
#import "LYUserList.h"
#import "LYUserFollowCell.h"
#import "LYUserInfoViewController.h"


@interface LYFollowUserListViewController () <LYActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) LYFollowUserListType listType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LYUserList *userList;
@property (nonatomic, strong) NSString *uid;

@end

@implementation LYFollowUserListViewController

+ (instancetype)viewControllerWithListType:(LYFollowUserListType)listType uid:(NSString *)uid {
    LYFollowUserListViewController *vc = [[LYFollowUserListViewController alloc] init];
    vc.listType = listType;
    vc.uid = uid;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LYUserListType userListType;
    switch (self.listType) {
        case LYFollowUserListTypeFriends:
        {
            if (!self.uid || [self.uid isEqualToString:[LYLogin sharedLogin].uid]) {
                self.navigationItem.title = @"我的好友";
            } else {
                self.navigationItem.title = @"他的好友";
            }
            userListType = LYUserListTypeFriends;
        }
            break;
        case LYFollowUserListTypeFollowers:
        {
            if (!self.uid || [self.uid isEqualToString:[LYLogin sharedLogin].uid]) {
                self.navigationItem.title = @"我的粉丝";
            } else {
                self.navigationItem.title = @"他的粉丝";
            }
            userListType = LYUserListTypeFollowers;
        }
            break;
    }
    self.userList = [LYUserList userListWithType:userListType];
    self.userList.uid = self.uid ?: [LYLogin sharedLogin].uid;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_more"] hightlightedImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(showMoreSheet)];
    
    self.tableView = ({
        UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tbView.dataSource = self;
        tbView.delegate = self;
        tbView.backgroundColor = LYBackgroundColor;
        [tbView registerClass:[LYUserFollowCell class] forCellReuseIdentifier:kCellIdentifier_UserFollow];
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tbView];
        [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tbView;
    });
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    [header beginRefreshing];
}

#pragma mark - table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYUserFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserFollow forIndexPath:indexPath];
    cell.currentUser = self.userList.list[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LYUserFollowCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LYUserInfoViewController *vc = [[LYUserInfoViewController alloc] init];
    vc.currentUser = self.userList.list[indexPath.row];
    vc.followChanged = ^(LYUser *user) {
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMoreSheet {
    LYActionSheet *actionSheet = [[LYActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"刷新", @"返回首页", nil];
    [actionSheet show];
}

- (void)actionSheet:(LYActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    } else if (buttonIndex == 1) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - data

- (void)refresh {
    [self loadWithMore:NO];
}

- (void)loadMore {
    [self loadWithMore:YES];
}

- (void)loadWithMore:(BOOL)more {
    if (self.userList.isLoading) {
        return;
    }
    self.userList.loading = YES;
    self.userList.willLoadMore = more;
    
    ESWeakSelf
    [[LYNetworkTool sharedTool] requestGETWithPath:[self.userList toSearchPath] parameters:[self.userList toSearchParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        [strongSelf.tableView.mj_footer endRefreshing];
        strongSelf.userList.loading = NO;
        
        if (error) {
            [strongSelf.userList loadFailed];
        } else {
            [strongSelf.userList configWithData:data];
            [strongSelf.tableView reloadData];
        }
        
        [strongSelf.view configWithType:EaseBlankPageTypeDefault blank:strongSelf.userList.list.count <= 0 error:strongSelf.userList.isLoadFailed reloadBlock:nil];
    }];
}



@end
