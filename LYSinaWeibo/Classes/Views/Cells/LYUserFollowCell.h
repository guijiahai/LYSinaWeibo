//
//  LYUserFollowCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/27.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYUser;

extern NSString *const kCellIdentifier_UserFollow;

@interface LYUserFollowCell : UITableViewCell

@property (nonatomic, strong) LYUser *currentUser;

+ (CGFloat)cellHeight;

@end
