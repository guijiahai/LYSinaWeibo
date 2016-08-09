//
//  LYStatusDetailLikeCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailLikeCell.h"
#import "LYUser.h"

NSString *const kCellIdentifier_LYStatusDetailLike = @"LYStatusDetailLikeCell";

@interface LYStatusDetailLikeCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *separator;

@end

@implementation LYStatusDetailLikeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = ({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            iv.layer.cornerRadius = 20.0;
            iv.layer.masksToBounds = YES;
            [self.contentView addSubview:iv];
            iv;
        });
        
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconView.mas_right).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
            label;
        });
        
        _levelView = [[UIImageView alloc] init];
        [self.contentView addSubview:_levelView];
        [_levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(3);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView.mas_right).offset(10);
            make.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = [UIColor colorWithWhite:(highlighted ? 230.0 : 250.0)/255 alpha:1];
}

- (void)setCurrentUser:(LYUser *)currentUser {
    _currentUser = currentUser;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_currentUser.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    _nameLabel.text = _currentUser.screen_name;
    _nameLabel.textColor = _currentUser.mbrank.integerValue > 0 ? LYMainColor : [UIColor colorWithWhite:34.0/255 alpha:1];
    _levelView.hidden = _currentUser.mbrank.integerValue <= 0;
    if (_currentUser.mbrank.integerValue > 0) {
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%@", _currentUser.mbrank.stringValue];
        _levelView.image = [UIImage imageNamed:imageName];
    }
}

+ (CGFloat)cellHeight {
    return 50.0;
}

@end
