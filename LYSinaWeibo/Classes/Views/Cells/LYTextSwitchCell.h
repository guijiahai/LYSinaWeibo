//
//  LYTextSwitchCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_TextSwitch;
extern NSString *const kNibName_TextSwitchCell;

@interface LYTextSwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *mSwitch;

+ (CGFloat)cellHeight;

@end
