//
//  LYBaseViewController.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYBaseViewController : UIViewController

- (void)loginToOAuthController;
+ (void)logoutToOAuthController;

+ (UIViewController *)presentingViewController;
+ (void)presentViewController:(UIViewController *)viewController;

@end
