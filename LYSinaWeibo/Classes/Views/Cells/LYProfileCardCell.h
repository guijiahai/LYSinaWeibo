//
//  LYProfileCardCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_ProfileCard;

@class LYCard;

@interface LYProfileCardCell : UITableViewCell

@property (nonatomic, strong) LYCard *currentCard;

+ (CGFloat)cellHeight;

@end
