//
//  LYSettingTextIndicatorCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYSettingTextIndicatorCell.h"

NSString *const kCellIdentifier_SettingTextIndicator = @"LYSettingTextIndicatorCell";

@implementation LYSettingTextIndicatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.textColor = [UIColor grayColor];
        
        UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10.0, (self.height - self.textLabel.height) * 0.5, self.textLabel.width, self.textLabel.height);
    
    self.detailTextLabel.frame = CGRectMake(self.contentView.width - self.detailTextLabel.width, (self.contentView.height - self.detailTextLabel.height) * 0.5, self.detailTextLabel.width, self.detailTextLabel.height);
}

+ (CGFloat)cellHeight {
    return 44.0;
}

@end
