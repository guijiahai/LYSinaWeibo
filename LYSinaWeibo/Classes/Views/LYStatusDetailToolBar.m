//
//  LYStatusDetailToolBar.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailToolBar.h"

@interface LYStatusDetailToolBar ()

@property (nonatomic, strong) UIButton *retweetButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *spliter_horizon;
@property (nonatomic, strong) UIImageView *spliter_left;
@property (nonatomic, strong) UIImageView *spliter_right;

@end

@implementation LYStatusDetailToolBar

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:252.0/255 alpha:1];
        
        _retweetButton = [self createButtonWithIndex:LYStatusDetailToolBarButtonTypeRetweet];
        [_retweetButton setTitle:@"转发" forState:UIControlStateNormal];
        [_retweetButton setImage:[UIImage imageNamed:@"toolbar_icon_retweet"] forState:UIControlStateNormal];
        
        _commentButton = [self createButtonWithIndex:LYStatusDetailToolBarButtonTypeComment];
        [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"toolbar_icon_comment"] forState:UIControlStateNormal];
        
        _likeButton = [self createButtonWithIndex:LYStatusDetailToolBarButtonTypeLikeOrUnlike];
        [_likeButton setTitle:@"赞" forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"toolbar_icon_unlike"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"toolbar_icon_like"] forState:UIControlStateSelected];
        
        [_retweetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(1);
            make.left.bottom.equalTo(self);
            make.width.mas_equalTo(kScreen_Width / 3.0 - 1);
        }];
        
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(1);
            make.bottom.equalTo(self);
            make.left.equalTo(_retweetButton.mas_right).offset(1);
            make.width.mas_equalTo(kScreen_Width / 3.0);
        }];
        
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(1);
            make.bottom.right.equalTo(self);
            make.width.mas_equalTo(kScreen_Width / 3.0 - 1);
        }];
        
        _spliter_horizon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self addSubview:_spliter_horizon];
        [_spliter_horizon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
        _spliter_left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_vertical_separator"]];
        [self addSubview:_spliter_left];
        [_spliter_left mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_retweetButton.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(1, 23));
        }];
        
        _spliter_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_vertical_separator"]];
        [self addSubview:_spliter_right];
        [_spliter_right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_commentButton.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(1, 23));
        }];
    }
    return self;
}

- (UIButton *)createButtonWithIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    [button addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:249.0/255 alpha:1]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:229.0/255 alpha:1]] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [button setTitleColor:[UIColor colorWithWhite:102.0/255 alpha:1] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}

- (void)didTouch:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(statusDetailToolBar:didTouchWithButtonType:)]) {
        [self.delegate statusDetailToolBar:self didTouchWithButtonType:button.tag];
    }
}

@end
