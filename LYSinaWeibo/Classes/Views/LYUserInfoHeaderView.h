//
//  LYUserInfoHeaderView.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/30.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYUser;

@interface LYUserInfoHeaderView : UIView

@property (nonatomic, strong) LYUser *currentUser;

@property (nonatomic, copy) void (^userIconClicked)();
@property (nonatomic, copy) void (^vipButtonClicked)();
@property (nonatomic, copy) void (^followButtonClicked)();
@property (nonatomic, copy) void (^fanButtonClicked)();
@property (nonatomic, copy) void (^editUserInfo)();

+ (instancetype)headerViewWithUser:(LYUser *)user;

- (void)reloadData;

@end
