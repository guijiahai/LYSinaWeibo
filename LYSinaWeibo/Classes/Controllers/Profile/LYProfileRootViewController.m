//
//  LYProfileRootViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYProfileRootViewController.h"
#import "LYSettingViewController.h"
#import "LYStatusOfMeViewController.h"
#import "LYFollowUserListViewController.h"
#import "LYUserInfoViewController.h"

#import "LYProfileHeaderCell.h"
#import "LYProfileCardCell.h"

#import "LYCards.h"

@interface LYProfileRootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) LYCards *cards;

@end

@implementation LYProfileRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我";

    if (![LYLogin sharedLogin].isLogin) {
        
        
        
    } else {
        
        [self tableView];
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultNormalItemWithTitle:@"添加好友" target:self action:@selector(addNewFriend)];
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem defaultNormalItemWithTitle:@"设置" target:self action:@selector(setting)];
        
        self.cards = [[LYCards alloc] init];
        
        [self refresh];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:kNibName_ProfileHeaderCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_ProfileHeader];
        [_tableView registerClass:[LYProfileCardCell class] forCellReuseIdentifier:kCellIdentifier_ProfileCard];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cards.groups.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.cards.groups[section - 1].cards.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LYProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProfileHeader forIndexPath:indexPath];
        cell.currentUser = [LYLogin sharedLogin].currentUser;
        ESWeakSelf
        cell.didTapHandler = ^(LYProfileHeaderCellTapType type) {
            ESStrongSelf
            switch (type) {
                case LYProfileHeaderCellTapTypeStatus:
                    [strongSelf showStatusList];
                    break;
                case LYProfileHeaderCellTapTypeFriends:
                    [strongSelf showFriendsList];
                    break;
                case LYProfileHeaderCellTapTypeFollowers:
                    [strongSelf showFollowersList];
                    break;
            }
        };
        return cell;
        
    } else {
        
        LYCard *card = self.cards.groups[indexPath.section - 1].cards[indexPath.row];
        LYProfileCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProfileCard forIndexPath:indexPath];
        cell.currentCard = card;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LYProfileHeaderCell cellHeight];
    } else {
        return [LYProfileCardCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] - 1) {
        return 10.0;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        LYUserInfoViewController *vc = [[LYUserInfoViewController alloc] init];
        vc.currentUser = [LYLogin sharedLogin].currentUser;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - data

- (void)refresh {
    ESWeakSelf
    [self.view configWithType:EaseBlankPageTypeCommentAtMe blank:NO error:NO reloadBlock:nil];
    
    [[LYNetworkTool sharedTool] requestGETWithPath:[self.cards toSearchPath] parameters:[self.cards toSearchParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        if (!error) {
            [strongSelf.cards configWithData:data];
            [strongSelf.tableView reloadData];
        } else {
            [strongSelf.view configWithType:EaseBlankPageTypeProfile blank:YES error:YES reloadBlock:^{
                [strongSelf refresh];
            }];
        }
    }];
}

- (void)addNewFriend {
    
}

- (void)setting {
    LYSettingViewController *vc = [[LYSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showStatusList {
    LYStatusOfMeViewController *vc = [[LYStatusOfMeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFriendsList {
    LYFollowUserListViewController *vc = [LYFollowUserListViewController viewControllerWithListType:LYFollowUserListTypeFriends uid:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFollowersList {
    LYFollowUserListViewController *vc = [LYFollowUserListViewController viewControllerWithListType:LYFollowUserListTypeFollowers uid:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
