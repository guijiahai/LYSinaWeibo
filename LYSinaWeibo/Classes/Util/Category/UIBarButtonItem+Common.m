//
//  UIBarButtonItem+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "UIBarButtonItem+Common.h"

@implementation UIBarButtonItem (Common)

+ (instancetype)itemWithImage:(UIImage *)image hightlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    button.frame = (CGRect){0, 0, button.currentImage.size};
//    button.imageEdgeInsets = UIEdgeInsetsMake(0, 5.0, 0, -5.0);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (UIButton *)defautlBackButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"navigationbar_back_withtext"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationbar_back_withtext_highlighted"] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:96.0/255 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:LYMainColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 6);
    [button sizeToFit];
    return button;
}

+ (instancetype)defaultBackItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [self defautlBackButtonWithTitle:title];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (instancetype)defaultBackItemWithTitle:(NSString *)title viewController:(UIViewController *)viewController {
    
    __weak typeof(viewController) weakVC = viewController;
    UIButton *button = [self defautlBackButtonWithTitle:title];
    [button bk_addEventHandler:^(id  _Nonnull sender) {
        __strong typeof(weakVC) strongVC = weakVC;
        if (strongVC) {
            if ([strongVC isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)strongVC popViewControllerAnimated:YES];
            } else if (strongVC.navigationController) {
                [strongVC.navigationController popViewControllerAnimated:YES];
            }
        }
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

+ (instancetype)defaultNormalItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithWhite:96.0/255 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:LYMainColor forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (instancetype)composeItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 123456789;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [button setBackgroundImage:[[UIImage imageNamed:@"common_button_big_orange"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"common_button_big_orange_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[[UIImage imageNamed:@"common_button_alpha"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)] forState:UIControlStateDisabled];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    CGSize size = [button sizeThatFits:CGSizeMake(300, 30)];
    button.frame = (CGRect){0, 0, size.width, 30};
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    return item;
}

- (void)setButtonTitle:(NSString *)title {
    UIView *customView = self.customView;
    if (customView && customView.tag == 123456789 && [customView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)customView;
        [button setTitle:title forState:UIControlStateNormal];
        CGSize size = [button sizeThatFits:CGSizeMake(300, 30)];
        button.bounds = (CGRect){0, 0, size.width, 30};
    }
}



@end
