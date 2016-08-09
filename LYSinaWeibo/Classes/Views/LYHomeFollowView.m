//
//  LYHomeFollowView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYHomeFollowView.h"

@interface LYHomeFollowView ()

@property (nonatomic, strong) UIImageView *homeImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *followButton;

@end

@implementation LYHomeFollowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = LYBackgroundColor;
        
        _homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_feed_image_house"]];
        [self addSubview:_homeImageView];
        
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor colorWithWhite:209.0/255 alpha:1];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.text = @"关注一些人，看看有什么惊喜";
        [self addSubview:_textLabel];
        
        _followButton = [UIButton buttonWithStyle:StrapButtonStyleOrange];
        [_followButton setTitle:@"去关注" forState:UIControlStateNormal];
        [self addSubview:_followButton];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        
        [_homeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.textLabel.mas_top).offset(-30);
        }];
        
        [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(160, 50));
            make.centerX.equalTo(self);
            make.top.equalTo(_textLabel.mas_bottom).offset(30);
        }];
        
    }
    return self;
}

@end
