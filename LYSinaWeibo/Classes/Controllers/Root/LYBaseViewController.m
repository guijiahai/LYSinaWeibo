//
//  LYBaseViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseViewController.h"
#import "LYOAuthViewController.h"
#import "AppDelegate.h"

@interface LYBaseViewController ()

@end

@implementation LYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loginToOAuthController {
    LYOAuthViewController *authVC = [LYOAuthViewController new];
    LYBaseNavigationController *nav = [[LYBaseNavigationController alloc] initWithRootViewController:authVC];
    [self presentViewController:nav animated:YES completion:nil];
}

+ (void)logoutToOAuthController {
    [(AppDelegate *)[UIApplication sharedApplication].delegate setupTabBarController];
    LYOAuthViewController *authVC = [LYOAuthViewController new];
    LYBaseNavigationController *nav = [[LYBaseNavigationController alloc] initWithRootViewController:authVC];
    [kKeyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

+ (UIViewController *)presentingViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [[(UITabBarController *)result viewControllers] objectAtIndex:[(UITabBarController *)result selectedIndex]];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (void)presentViewController:(UIViewController *)viewController {
    if (!viewController) {
        return;
    }
    LYBaseNavigationController *nav = [[LYBaseNavigationController alloc] initWithRootViewController:viewController];
    if (!viewController.navigationItem.leftBarButtonItem) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissViewControllerAnimated:completion:)];
    }
    [[self presentingViewController] presentViewController:nav animated:YES completion:nil];
}

@end
