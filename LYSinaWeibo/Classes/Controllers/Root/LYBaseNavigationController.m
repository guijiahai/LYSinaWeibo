//
//  LYBaseNavigationController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseNavigationController.h"

@interface LYBaseNavigationController ()

@end

@implementation LYBaseNavigationController

+ (void)initialize {
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:96.0/255 alpha:1]} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:50.0/255 alpha:1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = nil;
    [self recoverNavigationBarBackground];
}

- (void)makeNavigationBarBackgroundTransparent {
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)recoverNavigationBarBackground {
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:247.0/255 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageNamed:@"navigationbar_shadow"]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:50.0/255 alpha:1]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultBackItemWithTitle:self.topViewController.navigationItem.title ?: @"返回" target:self action:@selector(p_goBack)];
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)p_goBack {
    [self popViewControllerAnimated:YES];
}

@end
