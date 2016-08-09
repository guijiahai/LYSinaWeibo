//
//  LYTabBar.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYTabBar.h"

@interface LYTabBar ()

@property (nonatomic, strong) UIButton *composeButton;

@end

@implementation LYTabBar

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_composeButton setBackgroundColor:LYMainColor];
        [_composeButton addTarget:self action:@selector(composeClick) forControlEvents:UIControlEventTouchUpInside];
        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [_composeButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        _composeButton.layer.cornerRadius = 4.0;
        _composeButton.layer.masksToBounds = YES;
        [self addSubview:_composeButton];
        
        self.backgroundImage = [UIImage imageWithColor:[UIColor colorWithWhite:249.0/255 alpha:1]];
//        self.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
        self.shadowImage = [UIImage imageNamed:@"tabbar_shadow"];
    }
    return self;
}

- (void)composeClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarDidSelectComposeItem:)]) {
        [self.delegate tabBarDidSelectComposeItem:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.composeButton.bounds = CGRectMake(0, 0, 48, 42);
    self.composeButton.center = CGPointMake(self.width / 2, self.height / 2);
    
    CGFloat width = self.width / 5;
    NSInteger index = 0;
    for (UIView *item in self.subviews) {
        if ([item isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            item.x = width * (index > 1 ? index + 1 : index) - 5;
            index ++;
        }
    }
}

@end
