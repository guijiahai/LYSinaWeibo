//
//  LYStatusDetailSegmentView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailSegmentView.h"

static CGFloat const kStatusDetailSegmentHeight = 2.0;

@interface LYStatusDetailSegmentView ()

@property (nonatomic, strong) UIButton *retweetButton, *commentButton, *likeButton;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) UIImageView *separator;

@end

@implementation LYStatusDetailSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _selectedButtonType = LYStatusDetailSegmentButtonTypeComment;
        
        _retweetButton = [self createButtonWithIndex:LYStatusDetailSegmentButtonTypeRetweet];
        [_retweetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-kStatusDetailSegmentHeight);
        }];
        
        _commentButton = [self createButtonWithIndex:LYStatusDetailSegmentButtonTypeComment];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_retweetButton.mas_right).offset(15);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-kStatusDetailSegmentHeight);
        }];
        
        _likeButton = [self createButtonWithIndex:LYStatusDetailSegmentButtonTypeLike];
        [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-kStatusDetailSegmentHeight);
        }];
        
        _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(1);
        }];
        
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor = LYMainColor;
        [self addSubview:_indicator];
    }
    return self;
}

- (UIButton *)createButtonWithIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithWhite:153.0/255 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:button];
    return button;
}

- (void)setRetweetCount:(NSUInteger)retweetCount commentCount:(NSUInteger)commentCount likeCount:(NSUInteger)likeCount {
    self.retweetCount = retweetCount;
    self.commentCount = commentCount;
    self.likeCount = likeCount;
}

- (void)setRetweetCount:(NSUInteger)retweetCount {
    _retweetCount = retweetCount;
    [_retweetButton setTitle:[NSString stringWithFormat:@"转发 %ld", _retweetCount] forState:UIControlStateNormal];
}

- (void)setCommentCount:(NSUInteger)commentCount {
    _commentCount = commentCount;
    [_commentButton setTitle:[NSString stringWithFormat:@"评论 %ld", _commentCount] forState:UIControlStateNormal];
}

- (void)setLikeCount:(NSUInteger)likeCount {
    _likeCount = likeCount;
    [_likeButton setTitle:[NSString stringWithFormat:@"赞 %ld", _likeCount] forState:UIControlStateNormal];
}

- (void)setSelectedButtonType:(LYStatusDetailSegmentButtonType)selectedButtonType {
    if (_selectedButtonType == selectedButtonType) {
        return;
    }
    _selectedButtonType = selectedButtonType;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIButton *button = nil;
    switch (self.selectedButtonType) {
        case LYStatusDetailSegmentButtonTypeRetweet:
            button = self.retweetButton;
            break;
        case LYStatusDetailSegmentButtonTypeComment:
            button = self.commentButton;
            break;
        case LYStatusDetailSegmentButtonTypeLike:
            button = self.likeButton;
            break;
    }
    if (button) {
        [UIView animateWithDuration:(self.indicator.height == 0.0 ? 0.0 : 0.25) animations:^{
            self.indicator.frame = CGRectMake(button.x - 2.0, self.height - kStatusDetailSegmentHeight, button.width + 4.0, kStatusDetailSegmentHeight);
        }];
    }
}

- (void)buttonClick:(UIButton *)sender {
    sender.selected = YES;
    self.selectedButtonType = sender.tag;
    switch (sender.tag) {
        case LYStatusDetailSegmentButtonTypeRetweet:
        {
            self.commentButton.selected = self.likeButton.selected = NO;
        }
            break;
        case LYStatusDetailSegmentButtonTypeComment:
        {
            self.retweetButton.selected = self.likeButton.selected = NO;
        }
            break;
        case LYStatusDetailSegmentButtonTypeLike:
        {
            self.retweetButton.selected = self.commentButton.selected = NO;
        }
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(statusDetailSegmentView:didTouchWithButtonType:)]) {
        [self.delegate statusDetailSegmentView:self didTouchWithButtonType:self.selectedButtonType];
    }
}

@end
