//
//  LYTextCheckMarkCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYTextCheckMarkCell.h"

NSString *const kCellIdentifier_TextCheckMark = @"LYTextCheckMarkCell";
NSString *const kNibName_TextCheckMarkCell = @"LYTextCheckMarkCell";

@interface LYTextCheckMarkCell ()

@property (weak, nonatomic) IBOutlet UIImageView *checkView;

@end

@implementation LYTextCheckMarkCell


- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.checkMark = NO;
}

- (void)setCheckMark:(BOOL)checkMark {
    self.checkView.hidden = !checkMark;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = highlighted ? [UIColor colorWithWhite:235.0/255 alpha:1] : [UIColor whiteColor];
}

+ (CGFloat)cellHeight {
    return 44.0;
}

@end
