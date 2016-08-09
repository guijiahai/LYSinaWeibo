//
//  UIButton+Common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StrapButtonStyle) {
    StrapButtonStyleDefault,
    StrapButtonStyleOrange
};

@interface UIButton (Common)

+ (instancetype)buttonWithStyle:(StrapButtonStyle)style;

@end
