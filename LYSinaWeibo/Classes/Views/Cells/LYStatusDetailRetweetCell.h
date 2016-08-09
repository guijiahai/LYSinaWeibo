//
//  LYStatusDetailRetweetCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYStatus;

extern NSString *const kCellIdentifier_LYStatusDetailRetweet;

@interface LYStatusDetailRetweetCell : UITableViewCell

@property (nonatomic, strong) LYStatus *currentStatus;

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status;

@end
