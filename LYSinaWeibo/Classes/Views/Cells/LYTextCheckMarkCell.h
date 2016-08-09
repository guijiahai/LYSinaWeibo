//
//  LYTextCheckMarkCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_TextCheckMark;
extern NSString *const kNibName_TextCheckMarkCell;

@interface LYTextCheckMarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) BOOL checkMark;

+ (CGFloat)cellHeight;

@end
