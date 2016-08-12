//
//  UIImage+Common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame;

@end


@interface UIImage (UIImageQRCode)

+ (UIImage *)QRCodeWithInputMessage:(NSString *)inputMessage size:(CGSize)size;
+ (UIImage *)QRCodeWithInputMessage:(NSString *)inputMessage size:(CGSize)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

- (UIImage *)drawWithLogoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize;

- (NSString *)parseQRCode;

@end