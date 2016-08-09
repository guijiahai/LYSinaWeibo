//
//  LYStatusAtMeCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/17.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYStatus;

extern NSString *const kCellIdentifier_StatusAtMe;

@interface LYStatusAtMeCell : UITableViewCell

@property (nonatomic, strong) LYStatus *currentStatus;

@property (nonatomic, assign) BOOL canLoadImage;

@property (nonatomic, copy) void(^showRetweetedStatus)(LYStatus *status);

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status;

@end
