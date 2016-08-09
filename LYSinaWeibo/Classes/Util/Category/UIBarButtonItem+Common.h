//
//  UIBarButtonItem+Common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Common)

+ (instancetype)itemWithImage:(nullable UIImage *)image hightlightedImage:(nullable UIImage *)highlightedImage target:(nullable id)target action:(nullable SEL)action;

+ (nullable instancetype)defaultBackItemWithTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action;
+ (nullable instancetype)defaultBackItemWithTitle:(NSString *)title viewController:(UIViewController *)viewController;

/* 普通的title item */
+ (nullable instancetype)defaultNormalItemWithTitle:(NSString *)title target:(nullable id)target action:(nullable SEL)action;

/* 用于发布微博时界面的item */
+ (nullable instancetype)composeItemWithTitle:(nullable NSString *)title target:(nullable id)target action:(nullable SEL)action;
- (void)setButtonTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END