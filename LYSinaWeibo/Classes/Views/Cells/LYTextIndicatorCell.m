//
//  LYTextIndicatorCell.m
//  LYSinaWeibo
//
//  Created by 桂家海 on 16/7/23.
//  Copyright © 2016年 桂家海. All rights reserved.
//

#import "LYTextIndicatorCell.h"

NSString *const kCellIdentifier_TextIndicator = @"LYTextIndicatorCell";

@interface LYTextIndicatorCell ()

@end

@implementation LYTextIndicatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryView = [UIImageView alloc] initWithImage:[UIImage imageNamed:@""]
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
     self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (CGFloat)cellHeight {
    return 44.0;
}

@end
