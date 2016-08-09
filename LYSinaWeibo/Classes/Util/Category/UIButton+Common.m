//
//  UIButton+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)

+ (instancetype)buttonWithStyle:(StrapButtonStyle)style {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"common_button_white_highlighted"] forState:UIControlStateHighlighted];
    switch (style) {
        case StrapButtonStyleDefault:
            [button setTitleColor:[UIColor colorWithWhite:96.0/255 alpha:1 ] forState:UIControlStateNormal];
            break;
        case StrapButtonStyleOrange:
            [button setTitleColor:LYMainColor forState:UIControlStateNormal];
            break;
    }
    return button;
}

@end
