//
//  LYTabBar.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYTabBarDelegate;

@interface LYTabBar : UITabBar

@property (nonatomic, weak) id <LYTabBarDelegate, UITabBarDelegate> delegate;

@end

@protocol LYTabBarDelegate <NSObject>

- (void)tabBarDidSelectComposeItem:(LYTabBar *)tabBar;

@end