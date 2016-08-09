//
//  LYCommentAtMeViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/21.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYCommentAtMeViewController.h"
#import "LYCommentAtMeSettingViewController.h"

@interface LYCommentAtMeViewController ()



@end

@implementation LYCommentAtMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem defaultNormalItemWithTitle:@"设置" target:self action:@selector(setting)];

}

- (void)setting {
    LYCommentAtMeSettingViewController *vc = [[LYCommentAtMeSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
