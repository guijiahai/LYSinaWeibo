//
//  LYCollectionView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/11.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYCollectionView.h"

@implementation LYCollectionView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return self.superview;
    }
    return view;
}

@end
