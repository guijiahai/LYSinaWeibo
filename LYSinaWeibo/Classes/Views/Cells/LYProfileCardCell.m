//
//  LYProfileCardCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYProfileCardCell.h"
#import "LYCards.h"

NSString *const kCellIdentifier_ProfileCard = @"LYProfileCardCell";

@interface LYProfileCardCell ()

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *separator;

@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation LYProfileCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, ([[self class] cellHeight] - 24) * 0.5, 24, 24)];
        [self.contentView addSubview:self.iconView];
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.textColor = [UIColor grayColor];
        
        self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
        [self.contentView addSubview:self.arrowView];
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(12, 12));
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        
        self.separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:self.separator];
        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

- (void)setCurrentCard:(LYCard *)currentCard {
    _currentCard = currentCard;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_currentCard.pic]];
    self.textLabel.text = _currentCard.desc;
    self.detailTextLabel.text = _currentCard.desc_extr;
    self.arrowView.hidden = _currentCard.display_arrow.integerValue != 1;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(self.iconView.maxXOfFrame + 10, (self.contentView.height - self.textLabel.height) * 0.5, self.textLabel.width, self.textLabel.height);
    self.detailTextLabel.frame = CGRectMake(self.textLabel.maxXOfFrame + 10, (self.contentView.height - self.detailTextLabel.height) * 0.5, self.detailTextLabel.width, self.detailTextLabel.height);
}

+ (CGFloat)cellHeight {
    return 50.0;
}

@end
