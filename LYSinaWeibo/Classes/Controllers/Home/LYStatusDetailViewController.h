//
//  LYStatusDetailViewController.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseViewController.h"

@class LYStatus;

@interface LYStatusDetailViewController : LYBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) LYStatus *currentStatus;

@end
