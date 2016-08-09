//
//  LYSettingViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYSettingViewController.h"

#import "LYSettingTextIndicatorCell.h"
#import "LYSettingTextDangerCell.h"

#import "LYActionSheet.h"

@interface LYSettingViewController () <UITableViewDataSource, UITableViewDelegate, LYActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger cacheSize;


@end

@implementation LYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";

    self.tableView = ({
        UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tbView.dataSource = self;
        tbView.delegate = self;
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.backgroundColor = LYBackgroundColor;
        [tbView registerClass:[LYSettingTextIndicatorCell class] forCellReuseIdentifier:kCellIdentifier_SettingTextIndicator];
        [tbView registerClass:[LYSettingTextDangerCell class] forCellReuseIdentifier:kCellIdentifier_SettingTextDanger];
        [self.view addSubview:tbView];
        [tbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tbView;
    });
    
    [self calculateCacheSize];
}

- (void)calculateCacheSize {
    ESWeakSelf
    dispatch_async_inChild(^{
        weakSelf.cacheSize = [[SDWebImageManager sharedManager].imageCache getSize];
        dispatch_async_inMain(^{
            [weakSelf.tableView reloadData];
        });
    });
    
}

#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 2:
            return 2;
        case 1:
            return 3;
        case 3:
        case 4:
            return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        
        LYSettingTextDangerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SettingTextDanger forIndexPath:indexPath];
        cell.textLabel.text = @"退出微博";
        return cell;
        
    } else {
        LYSettingTextIndicatorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SettingTextIndicator forIndexPath:indexPath];
        
        NSString *title = nil, *detailTitle = nil;
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                        title = @"账号管理";
                        break;
                    case 1:
                        title = @"账号安全";
                        break;
                }
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0:
                        title = @"通知";
                        break;
                    case 1:
                        title = @"隐私";
                        break;
                    case 2:
                        title = @"通用设置";
                        break;
                }
            }
                break;
            case 2:
            {
                switch (indexPath.row) {
                    case 0:
                        title = @"意见反馈";
                        break;
                    case 1:
                        title = @"关于微博";
                        break;
                }
            }
                break;
            case 3:
            {
                title = @"清除缓存";
                detailTitle = [NSByteCountFormatter stringFromByteCount:self.cacheSize countStyle:NSByteCountFormatterCountStyleFile];
            }
                break;
        }
        
        cell.textLabel.text = title;
        cell.detailTextLabel.text = detailTitle;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        return [LYSettingTextDangerCell cellHeight];
    }
    return [LYSettingTextIndicatorCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                case 2:
                {
                    
                }
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                    
                case 1:
                {
                    [self aboutWeibo];
                }
                    break;
            }
        }
            break;
        case 3:
        {
            [self clearCache];
        }
            break;
        case 4:
        {
            [self exitWeibo];
        }
            break;
    }
}

#pragma mark - action

//账号管理
- (void)manageAccount {
    
}

//账号安全
- (void)accountSecurity {
    
}

//通知
- (void)notify {
    
}

//隐私
- (void)privacy {
    
}

//通用设置
- (void)generalSettings {
    
}

//意见反馈
- (void)feedback {
    
}

//关于微博
- (void)aboutWeibo {
    LYUser *user = [LYLogin sharedLogin].currentUser;
    
}

//清除缓存
- (void)clearCache {
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.4]];
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
        [SVProgressHUD dismiss];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"缓存已清除"];
        });
    }];
}

//退出微博
- (void)exitWeibo {
    LYActionSheet *sheet = [[LYActionSheet alloc] initWithTitle:@"退出账号将中断当前为发送完的内容" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil];
    [sheet show];
}

- (void)actionSheet:(LYActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[LYLogin sharedLogin] logout];
    [LYBaseViewController logoutToOAuthController];
}

@end
