//
//  LYMessageRootViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYMessageRootViewController.h"

#import "LYMessageStatusCell.h"
#import "LYMessageUserCell.h"

#import "LYStatusAtMeViewController.h"
#import "LYCommentAtMeViewController.h"

#import "LYSidePopoverView.h"
#import "LYMessageLoginView.h"

@interface LYMessageRootViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) LYMessageLoginView *loginView;

@end

@implementation LYMessageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息";
    
    if (![LYLogin sharedLogin].isLogin) {
        
        [self.view addSubview:self.loginView];
        
    } else {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultNormalItemWithTitle:@"发现群" target:self action:@selector(discoverGroup)];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_icon_newchat"] hightlightedImage:[UIImage imageNamed:@"navigationbar_icon_newchat_highlight"] target:self action:@selector(newChat)];
        
        _tableView = ({
            UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tbView.dataSource = self;
            tbView.delegate = self;
            tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tbView registerClass:[LYMessageUserCell class] forCellReuseIdentifier:kCellIdentifier_MessageUser];
            [tbView registerNib:[UINib nibWithNibName:NSStringFromClass([LYMessageStatusCell class]) bundle:nil] forCellReuseIdentifier:kCellIdentifier_MessageStatus];
            [self.view addSubview:tbView];
            tbView;
        });
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44.0)];
        _tableView.tableHeaderView = _searchBar;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_header = header;
    }
}

- (LYMessageLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[LYMessageLoginView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64.0 - self.tabBarController.tabBar.height)];
    }
    return _loginView;
}

- (void)refresh {
    
}

#pragma mark - table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYMessageStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MessageStatus forIndexPath:indexPath];
    cell.type = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LYMessageStatusCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LYStatusAtMeViewController *vc = [[LYStatusAtMeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        LYCommentAtMeViewController *vc = [[LYCommentAtMeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)discoverGroup {
    
}

- (void)newChat {
    LYSidePopoverView *popoverView = [[LYSidePopoverView alloc] initWithStyle:LYSidePopoverViewStyleRight titles:@[@"发起聊天", @"私密聊天"] images:@[[UIImage imageNamed:@"popover_icon_newchat"], [UIImage imageNamed:@"popover_icon_privatechat"]]];
    popoverView.didSelectRowAtIndex = ^(NSInteger index) {
        NSLog(@"%ld", index);
    };
    [popoverView show];
}


@end
