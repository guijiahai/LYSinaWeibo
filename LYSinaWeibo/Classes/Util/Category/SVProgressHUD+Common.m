//
//  SVProgressHUD+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "SVProgressHUD+Common.h"
#import <objc/runtime.h>

static CGFloat _maximumDismissTimeInterval = 0.0;

@implementation SVProgressHUD (Common)

+ (void)load {
    Method m1 = class_getClassMethod([SVProgressHUD class], @selector(displayDurationForString:));
    Method m2 = class_getClassMethod([SVProgressHUD class], @selector(common_displayDurationForString:));
    method_exchangeImplementations(m1, m2);
}

+ (void)setMaximumDismissTimeInterval:(CGFloat)maximumDismissTimeInterval {
    _maximumDismissTimeInterval = maximumDismissTimeInterval;
}

+ (NSTimeInterval)common_displayDurationForString:(NSString *)string {
    NSTimeInterval interval = [self common_displayDurationForString:string];
    if (_maximumDismissTimeInterval > 0.0) {
        interval = MIN(interval, _maximumDismissTimeInterval);
    }
    return interval;
}

@end
