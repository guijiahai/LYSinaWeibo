//
//  LYStatusAtMeSettingViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusAtMeSettingViewController.h"
#import "LYTextCheckMarkCell.h"
#import "LYSettingGuideCell.h"

@interface LYStatusAtMeSettingViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation LYStatusAtMeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"设置";
    
    self.currentIndex = 0;
    
    self.tableView = ({
        UITableView *tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [tbView registerNib:[UINib nibWithNibName:kNibName_TextCheckMarkCell bundle:nil] forCellReuseIdentifier:kCellIdentifier_TextCheckMark];
        [tbView registerClass:[LYSettingGuideCell class] forCellReuseIdentifier:kCellIdentifier_SettingGuide];
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
            return 2;
        case 1:
            return 3;
        case 2:
            return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }
    return 0;
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
        
        LYSettingGuideType type;
        if (indexPath.section == 1) {
            switch (self.currentIndex) {
                case 0:
                case 1:
                    type = LYSettingGuideTypeAtNumber;
                    break;
                case 2:
                    type = LYSettingGuideTypeAtDot;
                    break;
            }
        } else {
            if (self.currentIndex == 1) {
                type = LYSettingGuideTypeAtDot;
            }
        }
        LYSettingGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SettingGuide forIndexPath:indexPath];
        cell.type = type;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    return [title boundingHeightWithFont:[UIFont systemFontOfSize:12] size:CGSizeMake(kScreen_Width - 30.0, CGFLOAT_MAX)] + 25.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LYTextCheckMarkCell cellHeight];
    } else {
        return [LYSettingGuideCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"我将收到这些人的@通知";
    } else if (section == 1) {
        switch (self.currentIndex) {
            case 0:
                return @"所有的人@我时，都将在消息箱首页进行数字提醒，并将在应用外推送通知";
            case 1:
                return @"我关注的人@我时，将在消息箱首页进行数字提醒，并在应用外推送通知";
            case 2:
                return @"所有的人@我时，都将仅进行红点标记";
        }
    } else if (section == 2) {
        if (self.currentIndex == 1) {
            return @"未关注人@我时，将仅进行红点标记";
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.currentIndex = indexPath.row;
        [tableView reloadData];
    }
}

@end
