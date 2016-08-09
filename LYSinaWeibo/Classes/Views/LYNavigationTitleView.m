//
//  LYNavigationTitleView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/18.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYNavigationTitleView.h"

@interface LYNavigationTitleButton : UIButton

@end

@interface LYNavigationTitleView ()
@property (nonatomic, strong) LYNavigationTitleButton *button;
@end

@implementation LYNavigationTitleView

- (instancetype)init {
    if (self = [super init]) {
        _button = [LYNavigationTitleButton buttonWithType:UIButtonTypeCustom];
                _button.adjustsImageWhenHighlighted = NO;
        [_button setTitleColor:[UIColor colorWithWhite:34.0/255 alpha:1] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_button setBackgroundImage:[UIImage imageNamed:@"hotweibo_edit_button_background_default"] forState:UIControlStateHighlighted];
        [_button setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    [_button setTitle:_title forState:UIControlStateNormal];
    
    CGFloat width = [_title boundingWidthWithFont:[UIFont systemFontOfSize:17] size:CGSizeMake(kScreen_Width, 30)];
    CGFloat imageWidth = 13.0;
    
    CGFloat halfWidth = 0.0;
    halfWidth = width * 0.5;
    halfWidth += 5.0;
    halfWidth += imageWidth;
    halfWidth += 10.0;
    
    self.frame = CGRectMake(0, 0, halfWidth * 2, 30.0);
    
    [self.superview setNeedsLayout];
    [self.superview layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    _button.selected = _selected;
}

- (void)buttonClick:(UIButton *)sender {
    self.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationTitleViewDidSelectItem:)]) {
        [self.delegate navigationTitleViewDidSelectItem:self];
    }
}

@end

@implementation LYNavigationTitleButton

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize labelSize = self.titleLabel.frame.size;
    CGSize imageSize = self.imageView.frame.size;
    CGSize selfSize = self.frame.size;
    
    CGFloat halfWidth = 0.0;
    halfWidth = labelSize.width * 0.5;
    halfWidth += 5.0;
    halfWidth += imageSize.width;
    halfWidth += 10.0;
    
    self.titleLabel.frame = CGRectMake((selfSize.width - labelSize.width) / 2, (selfSize.height - labelSize.height) / 2, labelSize.width, labelSize.height);
    self.imageView.frame = CGRectMake(self.titleLabel.maxXOfFrame + 5, (selfSize.height - imageSize.height) / 2, imageSize.width, imageSize.height);
}

@end
