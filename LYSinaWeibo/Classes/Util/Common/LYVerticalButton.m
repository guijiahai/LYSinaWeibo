//
//  LYVerticalButton.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYVerticalButton.h"

@implementation LYVerticalButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor colorWithWhite:80.0/255 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return self;
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor colorWithWhite:80.0/255 alpha:1] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return self;
}

- (void)awakeFromNib {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor colorWithWhite:80.0/255 alpha:1] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:11.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake((self.width - self.currentImage.size.width) * 0.5, 0, self.currentImage.size.width, self.currentImage.size.height);
    self.titleLabel.frame = CGRectMake(0, self.imageView.height + 3.0, self.width, self.height - self.imageView.height);
}

- (void)setHighlighted:(BOOL)highlighted {
    if (self.beatWhenHighlighted) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.15];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        if (highlighted) {
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } else {
            self.transform = CGAffineTransformIdentity;
        }
        [UIView commitAnimations];
    } else {
        [super setHighlighted:highlighted];
    }
}

@end
