//
//  LYStatusListCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYStatus;

extern NSString *const kCellIdentifier_LYStatusList;

@interface LYStatusListCell : UITableViewCell

@property (nonatomic, strong) LYStatus *currentStatus;

@property (nonatomic, copy) void(^showRetweetedStatus)(LYStatus *retweetedStatus);

/* 默认为yes，如果设为no，则不会加载图片，并将imageView的image设为nil */
@property (nonatomic, assign) BOOL canLoadImage;

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status;

@end
