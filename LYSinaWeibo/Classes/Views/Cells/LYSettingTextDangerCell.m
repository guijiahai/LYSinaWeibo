//
//  LYSettingTextDangerCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYSettingTextDangerCell.h"

NSString *const kCellIdentifier_SettingTextDanger = @"LYSettingTextDangerCell";

@implementation LYSettingTextDangerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor colorWithRed:219.0/255 green:62.0/255 blue:35.0/255 alpha:1];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

+ (CGFloat)cellHeight {
    return 44.0;
}

@end
