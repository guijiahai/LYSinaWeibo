//
//  LYStatusDetailViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailViewController.h"
#import "LYStatusDetailCell.h"
#import "LYStatusDetailLoadCell.h"
#import "LYStatusDetailCommentCell.h"
#import "LYStatusDetailRetweetCell.h"
#import "LYStatusDetailLikeCell.h"
#import "LYStatusDetailToolBar.h"
#import "LYStatusDetailSegmentView.h"
#import "LYCommentList.h"
#import "LYStatusList.h"
#import "LYUserList.h"
#import "LYShareSheet.h"

@interface LYStatusDetailViewController () <LYStatusDetailToolBarDelegate, LYStatusDetailSegmentViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) LYStatusDetailToolBar *toolBar;
@property (nonatomic, strong) LYStatusDetailSegmentView *segmentView;

@property (nonatomic, assign) NSUInteger curSegmentIndex;   //default is 1 , comment

@property (nonatomic, strong) LYStatusList *retweetList;
@property (nonatomic, strong) LYCommentList *commentList;
@property (nonatomic, strong) LYUserList *likeList;

//@property (nonatomic, assign) BOOL firstLoad_retweet, firstLoad_comment, firstLoad_like;
@property (nonatomic, assign) CGPoint lastestOffset_retweet, lastestOffset_comment, latestOffset_like;

@end

@implementation LYStatusDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"微博正文";
    
//    _firstLoad_retweet = _firstLoad_comment = _firstLoad_like = YES;
    
    self.curSegmentIndex = 1;
    self.retweetList = [LYStatusList statusListWithType:LYStatusListTypeRepostTimeline];
    self.retweetList.originalStatusID = self.currentStatus.id;
    self.commentList = [LYCommentList commentListWithType:LYCommentListTypeStatus];
    self.commentList.originalStatusID = self.currentStatus.id;
    self.likeList = [LYUserList userListWithType:LYUserListTypeStatusLikes];
    self.likeList.originalStatusID = self.currentStatus.id;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_more"] hightlightedImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(showMoreSheet)];
    
    self.tableView = ({
        UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tbView.backgroundColor = LYBackgroundColor;
        tbView.dataSource = self;
        tbView.delegate = self;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tbView registerClass:[LYStatusDetailCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusDetail];
        [tbView registerClass:[LYStatusDetailLoadCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusDetailLoad];
        [tbView registerClass:[LYStatusDetailRetweetCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusDetailRetweet];
        [tbView registerClass:[LYStatusDetailCommentCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusDetailComment];
        [tbView registerClass:[LYStatusDetailLikeCell class] forCellReuseIdentifier:kCellIdentifier_LYStatusDetailLike];
        [self.view addSubview:tbView];
        [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-44);
        }];
        tbView;
    });
    
    _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.0)];
    _tableFooterView.backgroundColor = LYBackgroundColor;
    self.tableView.tableFooterView = _tableFooterView;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshStatus)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    _toolBar = ({
        LYStatusDetailToolBar *tb = [[LYStatusDetailToolBar alloc] init];
        tb.delegate = self;
        [self.view addSubview:tb];
        [tb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(44);
        }];
        tb;
    });
    
    [self refreshComment];
}

- (void)showMoreSheet {
    LYShareSheet *sheet = [[LYShareSheet alloc] initWithStyle:LYShareSheetStyleStatusDetail];
    [sheet show];
}

#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if ((self.curSegmentIndex == 0 && self.retweetList.list.count <= 0) || (self.curSegmentIndex == 1 && self.commentList.list.count <= 0) || (self.curSegmentIndex == 2 && self.likeList.list.count <= 0)) {
            return 1;
        } else {
            switch (self.curSegmentIndex) {
                case 0:
                    return self.retweetList.list.count;
                case 1:
                    return self.commentList.list.count;
                case 2:
                    return self.likeList.list.count;
            }
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LYStatusDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusDetail forIndexPath:indexPath];
        cell.currentStatus = self.currentStatus;
        ESWeakSelf
        cell.showRetweetedStatus = ^(LYStatus *status) {
            if (status) {
                ESStrongSelf
                LYStatusDetailViewController *vc = [[LYStatusDetailViewController alloc] init];
                vc.currentStatus = status;
                [vc setHidesBottomBarWhenPushed:YES];
                [strongSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if ((self.curSegmentIndex == 0 && self.retweetList.list.count <= 0) || (self.curSegmentIndex == 1 && self.commentList.list.count <= 0) || (self.curSegmentIndex == 2 && self.likeList.list.count <= 0)) {
            LYStatusDetailLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusDetailLoad forIndexPath:indexPath];
            switch (self.curSegmentIndex) {
                case 0:
                {
                    cell.noDataText = @"还没有人转发";
                    if (self.retweetList.isLoading) {
                        cell.loadState = LYStatusDetailLoadStateIng;
                    } else if (self.retweetList.isLoadFailed) {
                        cell.loadState = LYStatusDetailLoadStateFailed;
                    } else {
                        cell.loadState = LYStatusDetailLoadStateNoData;
                    }
                    ESWeakSelf
                    cell.reloadBlock = ^{
                        ESStrongSelf
                        [strongSelf refreshRetweet];
                    };
                }
                    break;
                case 1:
                {
                    cell.noDataText = @"还没有人评论";
                    if (self.commentList.isLoading) {
                        cell.loadState = LYStatusDetailLoadStateIng;
                    } else if (self.commentList.isLoadFailed) {
                        cell.loadState = LYStatusDetailLoadStateFailed;
                    } else {
                        cell.loadState = LYStatusDetailLoadStateNoData;
                    }
                    ESWeakSelf
                    cell.reloadBlock = ^{
                        ESStrongSelf
                        [strongSelf refreshComment];
                    };
                }
                    break;
                case 2:
                {
                    cell.noDataText = @"还没有人点赞";
                    if (self.likeList.isLoading) {
                        cell.loadState = LYStatusDetailLoadStateIng;
                    } else if (self.likeList.isLoadFailed) {
                        cell.loadState = LYStatusDetailLoadStateFailed;
                    } else {
                        cell.loadState = LYStatusDetailLoadStateNoData;
                    }
                    ESWeakSelf
                    cell.reloadBlock = ^{
                        ESStrongSelf
                        [strongSelf refreshLike];
                    };
                }
                    break;
            }
            return cell;
            
        } else {
            //section 1 有数据
            
            if (self.curSegmentIndex == 0) {
                LYStatusDetailRetweetCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusDetailRetweet forIndexPath:indexPath];
                cell.currentStatus = self.retweetList.list[indexPath.row];
                return cell;
            } else if (self.curSegmentIndex == 1) {
                LYStatusDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusDetailComment forIndexPath:indexPath];
                cell.currentComment = self.commentList.list[indexPath.row];
                return cell;
                
            } else if (self.curSegmentIndex == 2) {
                LYStatusDetailLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LYStatusDetailLike forIndexPath:indexPath];
                cell.currentUser = self.likeList.list[indexPath.row];
                return cell;
            }
        }       
    }
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (!_segmentView) {
            _segmentView = [[LYStatusDetailSegmentView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
            _segmentView.delegate = self;
            _segmentView.selectedButtonType = self.curSegmentIndex;
        }
        [_segmentView setRetweetCount:self.currentStatus.reposts_count.integerValue commentCount:self.currentStatus.comments_count.integerValue likeCount:self.currentStatus.attitudes_count.integerValue];
        return _segmentView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44.0;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LYStatusDetailCell cellHeightWithStatus:self.currentStatus];
    } else {
        if ((self.curSegmentIndex == 0 && self.retweetList.list.count <= 0) || (self.curSegmentIndex == 1 && self.commentList.list.count <= 0) || (self.curSegmentIndex == 2 && self.likeList.list.count <= 0)) {
            return [LYStatusDetailLoadCell cellHeight];
        } else {
            switch (self.curSegmentIndex) {
                case 0:
                {
                    LYStatus *retweet = self.retweetList.list[indexPath.row];
                    if (retweet.cellHeight < 10.0) {
                        retweet.cellHeight = [LYStatusDetailRetweetCell cellHeightWithStatus:retweet];
                    }
                    return retweet.cellHeight;
                }
                case 1:
                {
                    LYComment *comment = self.commentList.list[indexPath.row];
                    if (comment.cellHeight < 10.0) {
                        comment.cellHeight = [LYStatusDetailCommentCell cellHeightWithComment:comment];
                    }
                    return comment.cellHeight;
                }
                case 2:
                {
                    return [LYStatusDetailLikeCell cellHeight];
                }
            }
        }
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    } else {
        return 0.0;
    }
}

#pragma mark - LYStatusDetailToolBarDelegate
- (void)statusDetailToolBar:(LYStatusDetailToolBar *)toolBar didTouchWithButtonType:(LYStatusDetailToolBarButtonType)buttonType {
    switch (buttonType) {
        case LYStatusDetailToolBarButtonTypeRetweet:    //转发
        {
            
        }
            break;
        case LYStatusDetailToolBarButtonTypeComment:    //评论
        {
            
        }
            break;
        case LYStatusDetailToolBarButtonTypeLikeOrUnlike:   // 赞或取消赞
        {
            
        }
            break;
    }
}

#pragma mark - LYStatusDetailSegmentViewDelegate
- (void)statusDetailSegmentView:(LYStatusDetailSegmentView *)segmentView didTouchWithButtonType:(LYStatusDetailSegmentButtonType)buttonType {
    
    switch (self.curSegmentIndex) {
        case 0:
            self.lastestOffset_retweet = self.tableView.contentOffset;
            break;
        case 1:
            self.lastestOffset_comment = self.tableView.contentOffset;
            break;
        case 2:
            self.latestOffset_like = self.tableView.contentOffset;
            break;
    }
    
    switch (buttonType) {
        case LYStatusDetailSegmentButtonTypeRetweet:
        {
            if (self.curSegmentIndex == buttonType) {
                [self refreshRetweet];
            } else  if (!self.retweetList.isLoadFailed && self.retweetList.list.count <= 0 && self.retweetList.list == nil) {
                [self refreshRetweet];
            }
        }
            break;
        case LYStatusDetailSegmentButtonTypeComment:
        {
            if (self.curSegmentIndex == buttonType) {
                [self refreshComment];
            } else if (!self.commentList.isLoadFailed && self.commentList.list.count <= 0 && self.commentList.list == nil) {
                [self refreshComment];
            }
        }
            break;
        case LYStatusDetailSegmentButtonTypeLike:
        {
            if (self.curSegmentIndex == buttonType) {
                [self refreshLike];
            } else if (!self.likeList.isLoadFailed && self.likeList.list.count <= 0 && self.likeList.list == nil) {
                [self refreshLike];
            }
        }
            break;
    }
    self.curSegmentIndex = buttonType;
    [self reloadTableView];
}

- (void)reloadTableView {
    CGPoint preContentOffset = self.tableView.contentOffset;
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    CGRect rect = [self.tableView rectForSection:1];
    self.tableFooterView.height = MAX(0, kScreen_Height - 64.0 - 44.0 - rect.size.height);
    self.tableView.tableFooterView = self.tableFooterView;
    
    CGPoint latestOffset;
    switch (self.curSegmentIndex) {
        case 0:
            latestOffset = self.lastestOffset_retweet;
            break;
        case 1:
            latestOffset = self.lastestOffset_comment;
            break;
        case 2:
            latestOffset = self.latestOffset_like;
            break;
    }
    
    //先判断即将到来的section_1之前是处于什么位置，section_1 header 是否滚动到顶部了
    if (latestOffset.y < rect.origin.y) {
        //如果没有滚动到顶部
        if (preContentOffset.y > rect.origin.y - 1.0) {
            //在跳转之前，setion_1 header 已经滚动到顶部
            self.tableView.contentOffset = CGPointMake(0, rect.origin.y);
        } else {
            //在跳转之前，setion_1 header 没有滚动到顶部，则tableView的contentOffset保持不变
            self.tableView.contentOffset = preContentOffset;
        }
    } else {
        //如果滚动到顶部了
        if (preContentOffset.y > rect.origin.y - 1.0) {
            self.tableView.contentOffset = latestOffset;
        } else {
            self.tableView.contentOffset = preContentOffset;
        }
    }
}

#pragma mark - 刷新微博
- (void)refreshStatus {
    ESWeakSelf
    
    [[LYNetworkTool sharedTool] requestGETWithPath:@"/2/statuses/show.json" parameters:@{@"id" : self.currentStatus.id, @"access_token" : [LYLogin sharedLogin].access_token} andBlock:^(id data, NSError *error) {
        ESStrongSelf
        [strongSelf.tableView.mj_header endRefreshing];
        if (!error) {
            strongSelf.currentStatus = [LYStatus mj_objectWithKeyValues:data];
            [strongSelf.tableView reloadData];
        }
    }];
}

#pragma mark - load retweet list
- (void)refreshRetweet {
    if (!self.retweetList.isLoading) {
//        self.firstLoad_retweet = NO;
        self.retweetList.loading = YES;
        self.retweetList.willLoadMore = NO;
        [self sendRequestRetweet];
    }
}

- (void)loadMoreRetweet {
    if (!self.retweetList.isLoading) {
        self.retweetList.loading = YES;
        self.retweetList.willLoadMore = YES;
        [self sendRequestRetweet];
    }
}

- (void)sendRequestRetweet {
    ESWeakSelf
    
    [[LYNetworkTool sharedTool] requestGETWithPath:[self.retweetList toInfoPath] parameters:[self.retweetList toInfoParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        strongSelf.retweetList.loading = NO;
        if (error) {
            [strongSelf.retweetList loadFailed];
            [strongSelf reloadTableView];
        } else {
            dispatch_async_inChild(^{   //防止数据解析时间过长
                [strongSelf.retweetList configWithData:data];
                dispatch_async_inMain(^{
                    [strongSelf reloadTableView];
                });
            });
        }
    }];
}

#pragma mark - load comment list
- (void)refreshComment {
    if (!self.commentList.isLoading) {
        self.commentList.loading = YES;
        self.commentList.willLoadMore = NO;
        [self sendRequestComment];
    }
}

- (void)loadMoreComment {
    if (!self.commentList.isLoading) {
        self.commentList.loading = YES;
        self.commentList.willLoadMore = YES;
        [self sendRequestComment];
    }
}

- (void)sendRequestComment {
    ESWeakSelf
    
    [[LYNetworkTool sharedTool] requestGETWithPath:[self.commentList toSearchPath] parameters:[self.commentList toSearchParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        strongSelf.commentList.loading = NO;
        if (error) {
            [strongSelf.commentList loadFailed];
            [strongSelf reloadTableView];
        } else {
            dispatch_async_inChild(^{      //防止数据解析时间过长
                [strongSelf.commentList configWithData:data];
                dispatch_async_inMain(^{
                    [strongSelf reloadTableView];
                });
            });
        }
    }];
}

#pragma mark - load like list
- (void)refreshLike {
    if (!self.likeList.isLoading) {
        self.likeList.loading = YES;
        self.likeList.willLoadMore = NO;
        [self sendRequestLike];
    }
}

//点赞列表只加载前50名
- (void)loadMoreLike {
}

- (void)sendRequestLike {
    ESWeakSelf
    
    [[LYNetworkTool sharedTool] requestGETWithPath:[self.likeList toSearchPath] parameters:[self.likeList toSearchParams] andBlock:^(id data, NSError *error) {
        ESStrongSelf
        strongSelf.likeList.loading = NO;
        if (error) {
            [strongSelf.likeList loadFailed];
            [strongSelf reloadTableView];
        } else {
            dispatch_async_inChild(^{
                [strongSelf.likeList configWithData:data];
                dispatch_async_inMain(^{
                    [strongSelf reloadTableView];
                });
            });
        }
    }];
}

@end
