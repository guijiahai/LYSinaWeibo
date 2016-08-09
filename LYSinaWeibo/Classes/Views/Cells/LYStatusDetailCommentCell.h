//
//  LYStatusDetailCommentCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYComment;

extern NSString *const kCellIdentifier_LYStatusDetailComment;

@interface LYStatusDetailCommentCell : UITableViewCell

@property (nonatomic, strong) LYComment *currentComment;

+ (CGFloat)cellHeightWithComment:(LYComment *)comment;

@end
