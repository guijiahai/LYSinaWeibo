//
//  LYTextSwitchCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYTextSwitchCell.h"

NSString *const kCellIdentifier_TextSwitch = @"LYTextSwitchCell";
NSString *const kNibName_TextSwitchCell = @"LYTextSwitchCell";

@implementation LYTextSwitchCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
}

+ (CGFloat)cellHeight {
    return 44.0;
}

@end
