//
//  LYUserFollowCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/27.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYUserFollowCell.h"
#import "LYVerticalButton.h"
#import "LYUser.h"

NSString *const kCellIdentifier_UserFollow = @"LYUserFollowCell";

@interface LYUserFollowCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) LYVerticalButton *followBtn;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIImageView *separator;

@end

@implementation LYUserFollowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = ({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
            iv.layer.cornerRadius = 25.0;
            iv.layer.masksToBounds = YES;
            iv.layer.borderColor = [UIColor lightGrayColor].CGColor;
            iv.layer.borderWidth = 1.0;
            [self.contentView addSubview:iv];
            iv;
        });
        
        self.vipView = ({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(49, 49, 14, 14)];
            iv.hidden = YES;
            [self.contentView addSubview:iv];
            iv;
        });
        
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor blackColor];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
            }];
            label;
        });
        
        self.levelView = ({
            UIImageView *iv = [[UIImageView alloc] init];
            iv.hidden = YES;
            [self.contentView addSubview:iv];
            iv;
        });
        
        
        self.descLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:label];
            label;
        });
        
        self.followBtn = ({
            LYVerticalButton *btn = [LYVerticalButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [self.contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView).offset(-15);
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(50, 40));
            }];
            btn;
        });
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.followBtn.mas_left).offset(-15);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
            make.right.equalTo(self.followBtn.mas_left).offset(-15);
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

- (void)setCurrentUser:(LYUser *)currentUser {
    _currentUser = currentUser;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_currentUser.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    _vipView.hidden = !_currentUser.verified;
    if (_currentUser.verified) {
        NSString *imageName = nil;
        switch (_currentUser.verified_type.integerValue) {
            case 0:
                imageName = @"avatar_vip";
                break;
            case 2:
            case 3:
            case 5:
                imageName = @"avatar_enterprise_vip";
                break;
            case 220:
                imageName = @"avatar_grassroot";
                break;
            default:
                break;
        }
        _vipView.image = imageName == nil ? nil : [UIImage imageNamed:imageName];
    }
    
    _nameLabel.text = _currentUser.screen_name;
    _nameLabel.textColor = _currentUser.mbrank.integerValue > 0 ? LYMainColor : [UIColor colorWithWhite:34.0/255 alpha:1];
    
    _levelView.hidden = _currentUser.mbrank.integerValue > 0;
    if (_currentUser.mbrank.integerValue > 0) {
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%@", _currentUser.mbrank.stringValue];
        _levelView.image = [UIImage imageNamed:imageName];
    }

    _descLabel.text = _currentUser.description_.length > 0 ? _currentUser.description_ : @"暂无介绍";
    
    
    //follow btn
    if (_currentUser.follow_me && _currentUser.following) {
        [_followBtn setImage:[UIImage imageNamed:@"card_icon_arrow"] forState:UIControlStateNormal];
        [_followBtn setTitle:@"互相关注" forState:UIControlStateNormal];
    } else if (_currentUser.following) {
        [_followBtn setImage:[UIImage imageNamed:@"card_icon_attention"] forState:UIControlStateNormal];
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [_followBtn setImage:[UIImage imageNamed:@"card_icon_addattention"] forState:UIControlStateNormal];
        [_followBtn setTitle:@"加关注" forState:UIControlStateNormal];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

+ (CGFloat)cellHeight {
    return 70.0;
}

@end
