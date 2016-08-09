//
//  LYUserInfoViewController.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/30.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseViewController.h"

@class LYUser;

@interface LYUserInfoViewController : LYBaseViewController

@property (nonatomic, strong) LYUser *currentUser;

@property (nonatomic, copy) void(^followChanged)(LYUser *user);

@end
