//
//  LYMessageUserCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/17.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYMessageUserCell.h"

NSString *const kCellIdentifier_MessageUser = @"LYMessageUserCell";

@interface LYMessageUserCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *dotView;
@property (nonatomic, strong) UIImageView *separator;

@end

@implementation LYMessageUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = ({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
            iv.layer.cornerRadius = 24.0;
            iv.layer.masksToBounds = YES;
            [self.contentView addSubview:iv];
            iv;
        });
        
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithWhite:180.0/255 alpha:1];
            label.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.top.equalTo(self.contentView).offset(10);
                make.width.mas_greaterThanOrEqualTo(50.0);
            }];
            label;
        });
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
            label.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconView.mas_right).offset(10);
                make.top.equalTo(self.contentView).offset(10);
                make.right.equalTo(_timeLabel.mas_left).offset(-10);
            }];
            label;
        });
        
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorWithWhite:180.0/255 alpha:1];
            label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.bottom.equalTo(_iconView);
                make.right.equalTo(_timeLabel.mas_left).offset(-10);
            }];
            label;
        });
        
        _dotView = ({
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_dot"]];
            [self.contentView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(_detailLabel);
                make.size.mas_equalTo(CGSizeMake(10, 10));
            }];
            iv;
        });
        
        _dotView.hidden = YES;
        
        
        _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_detailLabel);
            make.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

+ (CGFloat)cellHeight {
    return 68.0;
}

@end
