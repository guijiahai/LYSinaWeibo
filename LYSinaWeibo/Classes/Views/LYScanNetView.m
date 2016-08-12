//
//  LYScanNetView.m
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/10.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYScanNetView.h"

@interface LYScanNetView ()

@property (nonatomic, strong) UIImageView *netView;
@property (nonatomic, assign) BOOL animating;

@end

@implementation LYScanNetView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.netView];
    }
    return self;
}

- (UIImageView *)netView {
    if (!_netView) {
        _netView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrcode_scanline_qrcode"]];
        _netView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }
    return _netView;
}

- (void)beginAnimation {
    if (self.isAnimating) {
        return;
    }
    self.hidden = NO;
    self.animating = YES;
    [self stepAnimation];
}

- (void)stopAnimation {
    if (!self.isAnimating) {
        return;
    }
    self.hidden = YES;
    self.animating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)stepAnimation {
    if (!self.isAnimating) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.alpha = 0.5;
    self.netView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:2.0 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.alpha = 1.0;
        strongSelf.netView.frame = CGRectMake(0, strongSelf.frame.size.height * 0.8, strongSelf.frame.size.width, strongSelf.frame.size.height);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf performSelector:@selector(stepAnimation) withObject:nil afterDelay:0.0];
    }];
}

- (void)dealloc {
    [self stopAnimation];
}

@end
