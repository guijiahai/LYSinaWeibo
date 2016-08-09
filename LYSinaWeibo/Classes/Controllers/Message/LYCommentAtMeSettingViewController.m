//
//  LYCommentAtMeSettingViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/21.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYCommentAtMeSettingViewController.h"
#import "LYTextCheckMarkCell.h"
#import "LYSettingGuideCell.h"
#import "LYTextSwitchCell.h"

@interface LYCommentAtMeSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation LYCommentAtMeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    
    self.currentIndex = 0;
    
    self.tableView = ({
        UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [tbView registerNib:[UINib nibWithNibName:kNibName_TextCheckMarkCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_TextCheckMark];
        [tbView registerClass:[LYSettingGuideCell class] forCellReuseIdentifier:kCellIdentifier_SettingGuide];
        [tbView registerNib:[UINib nibWithNibName:kNibName_TextSwitchCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_TextSwitch];
        tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tbView.dataSource = self;
        tbView.delegate = self;
        [self.view addSubview:tbView];
        tbView;
    });
}


#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.currentIndex) {
        case 0:
        case 2:
            return 3;
        case 1:
            return 4;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        LYTextCheckMarkCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextCheckMark forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"所有人";
                break;
            case 1:
                cell.titleLabel.text = @"我关注的人";
                break;
            case 2:
                cell.titleLabel.text = @"关闭";
                break;
        }
        cell.checkMark = indexPath.row == self.currentIndex;
        return cell;
        
    } else {
        
        if (indexPath.section == 1 || (indexPath.section == 2 && self.currentIndex == 1)) {
            
            LYSettingGuideType type = 0;
            if (indexPath.section == 1) {
                switch (self.currentIndex) {
                    case 0:
                    case 1:
                        type = LYSettingGuideTypeCommentNumber;
                        break;
                    case 2:
                        type = LYSettingGuideTypeCommentDot;
                        break;
                }
            } else {
                type = LYSettingGuideTypeCommentDot;
            }
            
            LYSettingGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SettingGuide forIndexPath:indexPath];
            cell.type = type;
            return cell;
            
        } else {
                        
            LYTextSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextSwitch forIndexPath:indexPath];
            cell.titleLabel.text = @"我参与的";
            return cell;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"我将收到这些人的评论通知";
    } else if (section == 1) {
        switch (self.currentIndex) {
            case 0:
                return @"所有的人评论我时，都将在消息箱首页进行数字提醒，并将在应用外推送通知";
            case 1:
                return @"我关注的人评论我时，将在消息箱首页进行数字提醒，并在应用外推送通知";
            case 2:
                return @"所有的人评论我时，都将仅进行红点标记";
        }
    } else if (section == 2) {
        switch (self.currentIndex) {
            case 0:
            case 2:
                return nil;
            case 1:
                return @"未关注人评论我时，将仅进行红点标记";
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] - 1) {
        return @"开启后，当我评论或赞了一条微博，将收到我关注的人对这条微博的评论";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    return [title boundingHeightWithFont:[UIFont systemFontOfSize:12] size:CGSizeMake(kScreen_Width - 30.0, CGFLOAT_MAX)] + 25.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LYTextCheckMarkCell cellHeight];
    } else {
        if (indexPath.section == 1 || (indexPath.section == 2 && self.currentIndex == 1)) {
            return [LYSettingGuideCell cellHeight];
        } else {
            return [LYTextSwitchCell cellHeight];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections] - 1) {
        return 50.0;
    }
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.currentIndex = indexPath.row;
        [tableView reloadData];
    }
}


@end
