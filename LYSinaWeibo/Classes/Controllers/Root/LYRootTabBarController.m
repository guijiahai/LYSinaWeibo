//
//  LYRootTabBarController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYRootTabBarController.h"

#import "LYHomeRootViewController.h"
#import "LYMessageRootViewController.h"
#import "LYDiscoverRootViewController.h"
#import "LYProfileRootViewController.h"
#import "LYComposeRootViewController.h"

#import "LYTabBar.h"

@interface LYRootTabBarController () <LYTabBarDelegate>

@property (nonatomic, strong) LYTabBar *lyTabBar;

@end

@implementation LYRootTabBarController

+ (void)initialize {
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    [attrs setValue:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    [attrs setValue:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    [selectedAttrs setValue:[UIFont systemFontOfSize:10] forKey:NSFontAttributeName];
    [selectedAttrs setValue:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    
    [[UITabBarItem appearance] setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lyTabBar = [[LYTabBar alloc] init];
    _lyTabBar.delegate = self;
    [self setValue:_lyTabBar forKeyPath:@"tabBar"];
    
    LYHomeRootViewController *home = [LYHomeRootViewController new];
    home.tabBarItem.title = @"首页";
    home.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    LYBaseNavigationController *homeNav = [[LYBaseNavigationController alloc] initWithRootViewController:home];
    
    
    LYBaseNavigationController *messageNav = [[LYBaseNavigationController alloc] initWithRootViewController:[LYMessageRootViewController new]];
    messageNav.tabBarItem.title = @"消息";
    messageNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
    messageNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_message_center_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    LYBaseNavigationController *discoverNav = [[LYBaseNavigationController alloc] initWithRootViewController:[LYDiscoverRootViewController new]];
    discoverNav.tabBarItem.title = @"发现";
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    discoverNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    LYBaseNavigationController *meNav = [[LYBaseNavigationController alloc] initWithRootViewController:[LYProfileRootViewController new]];
    meNav.tabBarItem.title = @"我";
    meNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    meNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[homeNav, messageNav, discoverNav, meNav];
}

- (void)tabBarDidSelectComposeItem:(LYTabBar *)tabBar {
    LYComposeRootViewController *vc = [[LYComposeRootViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.tabBarController = self;
    [self presentViewController:vc animated:NO completion:nil];
}


@end
