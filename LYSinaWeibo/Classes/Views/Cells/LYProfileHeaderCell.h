//
//  LYProfileHeaderCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYUser;

extern NSString *const kCellIdentifier_ProfileHeader;
extern NSString *const kNibName_ProfileHeaderCell;

typedef NS_ENUM(NSInteger, LYProfileHeaderCellTapType) {
    LYProfileHeaderCellTapTypeStatus,
    LYProfileHeaderCellTapTypeFriends,
    LYProfileHeaderCellTapTypeFollowers
};

@interface LYProfileHeaderCell : UITableViewCell

@property (nonatomic, strong) LYUser *currentUser;

@property (nonatomic, copy) void(^didTapHandler)(LYProfileHeaderCellTapType type);

+ (CGFloat)cellHeight;

@end
