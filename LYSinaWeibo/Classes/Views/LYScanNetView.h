//
//  LYScanNetView.h
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/10.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYScanNetView : UIView

- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

- (void)beginAnimation;
- (void)stopAnimation;

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@end
