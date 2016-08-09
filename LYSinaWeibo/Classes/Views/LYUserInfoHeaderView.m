//
//  LYUserInfoHeaderView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/30.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYUserInfoHeaderView.h"
#import "LYUser.h"

static const CGFloat kUserInfoHeader_Height = 225.0;
static const CGFloat kUserInfoHeader_IconWidth = 75.0;

@interface LYUserInfoHeaderView ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *sexView;
@property (nonatomic, strong) UIButton *vipButton;
@property (nonatomic, strong) UIButton *followBtn, *fanBtn;
@property (nonatomic, strong) UIView *splitView;

@property (nonatomic, strong) UIControl *descBgView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *editView;

@end

@implementation LYUserInfoHeaderView

+ (instancetype)headerViewWithUser:(LYUser *)user {
    LYUserInfoHeaderView *headerView = [[LYUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kUserInfoHeader_Height)];
    headerView.currentUser = user;
    return headerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_cover_background.jpg"]];
        self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.coverView = [[UIView alloc] init];
        self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
        [self addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        ESWeakSelf
        
        self.iconView = ({
            UIImageView *iv = [[UIImageView alloc] init];
            iv.layer.cornerRadius = kUserInfoHeader_IconWidth * 0.5;
            iv.layer.masksToBounds = YES;
            iv.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
            iv.layer.borderWidth = 2.0;
            [self addSubview:iv];
            iv;
        });
        
        self.nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:17];
            [self addSubview:label];
            label;
        });
        
        self.sexView = ({
            UIImageView *iv = [[UIImageView alloc] init];
            [self addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(16, 16));
                make.centerY.equalTo(self.nameLabel);
                make.left.equalTo(self.nameLabel.mas_right).offset(5);
            }];
            iv;
        });
        
        self.vipButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.userInteractionEnabled = YES;
            [button setBackgroundImage:[UIImage imageNamed:@"common_icon_membership_expired_self"] forState:UIControlStateNormal];
            [button bk_addEventHandler:^(id  _Nonnull sender) {
                ESStrongSelf
                if (strongSelf.vipButtonClicked) {
                    strongSelf.vipButtonClicked();
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(36, 16));
                make.centerY.equalTo(self.nameLabel);
                make.left.equalTo(self.sexView.mas_right).offset(5);
            }];
            button;
        });
        
        self.followBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button bk_addEventHandler:^(id  _Nonnull sender) {
                ESStrongSelf
                if (strongSelf.followButtonClicked) {
                    strongSelf.followButtonClicked();
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button;
        });
        
        self.splitView = [[UIView alloc] init];
        self.splitView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.splitView];
        
        self.fanBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button bk_addEventHandler:^(id  _Nonnull sender) {
                ESStrongSelf
                if (strongSelf.fanButtonClicked) {
                    strongSelf.fanButtonClicked();
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            button;
        });
        
        self.descBgView = ({
            UIControl *control = [[UIControl alloc] init];
            [control bk_addEventHandler:^(id  _Nonnull sender) {
                ESStrongSelf
                if (strongSelf.editUserInfo) {
                    strongSelf.editUserInfo();
                }
            } forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:control];
            control;
        });
        
        UIView *descBg = [[UIView alloc] init];
        descBg.backgroundColor = [UIColor clearColor];
        [self.descBgView addSubview:descBg];
        
        self.descLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor whiteColor];
            [descBg addSubview:label];
            label;
        });
        
        self.editView = ({
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userinfo_relationship_indicator_edit"]];
            [descBg addSubview:iv];
            iv;
        });
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(descBg);
            make.width.mas_lessThanOrEqualTo(kScreen_Width - 76);
        }];
        [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descLabel.mas_right);
            make.right.equalTo(descBg);
            make.bottom.top.equalTo(descBg);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
        [descBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.descBgView);
        }];
        
        [self.descBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-20);
            make.height.mas_equalTo(16);
        }];
        
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self.mas_centerX).offset(-15);
            make.bottom.equalTo(self.descBgView.mas_top).offset(-7);
            make.height.mas_equalTo(17);
        }];
        
        [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(1.5, 12));
            make.centerY.equalTo(self.followBtn);
            make.centerX.equalTo(self);
        }];
        
        [self.fanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(15);
            make.right.equalTo(self).offset(-30);
            make.bottom.equalTo(self.descBgView.mas_top).offset(-7);
            make.height.mas_equalTo(17);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.followBtn.mas_top).offset(-7);
            make.centerX.equalTo(self);
        }];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.nameLabel.mas_top).offset(-7);
            make.size.mas_equalTo(CGSizeMake(kUserInfoHeader_IconWidth, kUserInfoHeader_IconWidth));
        }];

    }
    return self;
}


- (void)setCurrentUser:(LYUser *)currentUser {
    _currentUser = currentUser;
    [self reloadData];
}

- (void)reloadData {
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.currentUser.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    
    self.nameLabel.text = self.currentUser.screen_name;
    
    if ([self.currentUser.gender isEqualToString:@"m"]) {
        self.sexView.image = [UIImage imageNamed:@"userinfo_icon_male"];
        self.sexView.hidden = NO;
    } else if ([self.currentUser.gender isEqualToString:@"f"]) {
        self.sexView.image = [UIImage imageNamed:@"userinfo_icon_female"];
        self.sexView.hidden = NO;
    } else {
        self.sexView.hidden = YES;
    }
    
    [self.followBtn setTitle:[NSString stringWithFormat:@"关注 %@", self.currentUser.friends_count.stringValue] forState:UIControlStateNormal];
    [self.fanBtn setTitle:[NSString stringWithFormat:@"粉丝 %@", self.currentUser.followers_count.stringValue] forState:UIControlStateNormal];
    
    if (self.currentUser.description_.length > 0) {
        self.descLabel.text = [NSString stringWithFormat:@"简介:%@", self.currentUser.description_];
    } else {
        self.descLabel.text = @"简介:暂无介绍";
    }
    
    BOOL isMe = [self.currentUser.idStr isEqualToString:[LYLogin sharedLogin].currentUser.idStr];
    self.editView.hidden = !isMe;
    [self.editView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(isMe ? 16 : 1);
    }];
}


@end
