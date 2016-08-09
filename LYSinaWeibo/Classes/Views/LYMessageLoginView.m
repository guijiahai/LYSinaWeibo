//
//  LYMessageLoginView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYMessageLoginView.h"

@interface LYMessageLoginView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation LYMessageLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = LYBackgroundColor;
        
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visitordiscover_image_message"]];
        [self addSubview:_logoImageView];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [UIColor colorWithWhite:209.0/255 alpha:1];
        _textLabel.text = @"登录后，别人评论你的微薄，给你发消息，都会在这里收到通知";
        [self addSubview:_textLabel];
        
        _registerButton = [UIButton buttonWithStyle:StrapButtonStyleOrange];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [self addSubview:_registerButton];
  
        _loginButton = [UIButton buttonWithStyle:StrapButtonStyleDefault];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
        }];
        
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(_textLabel.mas_top);
        }];
        
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.top.equalTo(_textLabel.mas_bottom).offset(50);
            make.right.equalTo(self.mas_centerX).offset(-8);
            make.height.mas_equalTo(50);
        }];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(_registerButton);
            make.left.equalTo(_textLabel.mas_centerX).offset(8);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}

@end
