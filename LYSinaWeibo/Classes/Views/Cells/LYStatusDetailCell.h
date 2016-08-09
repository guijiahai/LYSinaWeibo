//
//  LYStatusDetailCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_LYStatusDetail;

@class LYStatus;

@interface LYStatusDetailCell : UITableViewCell

@property (nonatomic, strong) LYStatus *currentStatus;

@property (nonatomic, copy) void (^showRetweetedStatus)(LYStatus *status);

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status;

@end
