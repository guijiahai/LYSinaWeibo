//
//  LYMessageStatusCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_MessageStatus;

typedef NS_ENUM(NSInteger, LYMessageStatusType) {
    LYMessageStatusTypeAT,
    LYMessageStatusTypeComment,
    LYMessageStatusTypeLike
};

@interface LYMessageStatusCell : UITableViewCell

@property (nonatomic, assign) LYMessageStatusType type;

+ (CGFloat)cellHeight;

@end
