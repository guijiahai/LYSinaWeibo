//
//  LYStatusDetailLikeCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYUser;

extern NSString *const kCellIdentifier_LYStatusDetailLike;

@interface LYStatusDetailLikeCell : UITableViewCell

@property (nonatomic, strong) LYUser *currentUser;

+ (CGFloat)cellHeight;

@end
