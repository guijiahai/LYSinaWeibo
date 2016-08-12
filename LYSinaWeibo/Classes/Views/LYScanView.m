//
//  LYScanView.m
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/10.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYScanView.h"
#import "LYScanNetView.h"

static CGFloat kScanHorizontalOffset;
static CGFloat kScanCenterUpOffset;

@interface LYScanView ()

@property (nonatomic, strong) UIImageView *borderView;
@property (nonatomic, strong) LYScanNetView *netView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *cardButton, *flashButton;

@end

@implementation LYScanView

+ (void)initialize {
    kScanCenterUpOffset = 100.0;
    kScanHorizontalOffset = [UIScreen mainScreen].bounds.size.width * 0.2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.netView = [[LYScanNetView alloc] init];
        [self addSubview:self.netView];
        [self addSubview:self.cardButton];
        [self stateLabel];
    }
    return self;
}

- (void)cardButtonClicked:(UIButton *)sender {
    if (self.cardButtonClickedBlock) {
        self.cardButtonClickedBlock();
    }
}

- (void)flashButtonClicked:(UIButton *)sender {
    if (self.flashButtonClickedBlock) {
        BOOL selected = self.flashButtonClickedBlock();
        sender.selected = selected;
    }
}

- (void)setShowFlashButton:(BOOL)showFlashButton {
    _showFlashButton = showFlashButton;
    if (_showFlashButton) {
        if (!self.flashButton.superview) {
            [self addSubview:self.flashButton];
        }
    } else {
        if (_flashButton && _flashButton.superview) {
            [_flashButton removeFromSuperview];
        }
    }
    [self layoutIfNeeded];
}

- (void)prepareDeviceWithText:(NSString *)text {
    CGSize sizeOfRectangle = [[self class] sizeOfRectangleWithFrame:self.frame];
    CGFloat minYOfRectangle = [[self class] minYOfRectangleWithFrame:self.frame];
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.center = CGPointMake(kScanHorizontalOffset + sizeOfRectangle.width * 0.5 - 50, minYOfRectangle + sizeOfRectangle.height * 0.5);
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
        
        _prepareLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indicatorView.maxXOfFrame + 10, _indicatorView.y, 100, 30)];
        _prepareLabel.backgroundColor = [UIColor clearColor];
        _prepareLabel.textColor = [UIColor whiteColor];
        _prepareLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_prepareLabel];
    }
    
    [_indicatorView startAnimating];
    _prepareLabel.text = text;
    _prepareLabel.hidden = NO;
}


- (void)stopToPrepareDevice {
    if (_indicatorView) {
        [_indicatorView stopAnimating];
    }
    if (_prepareLabel) {
        _prepareLabel.hidden = YES;
    }
}

- (BOOL)isAnimating {
    return self.netView.isAnimating;
}

- (void)beginScanAnimation {
    [self.netView beginAnimation];
}

- (void)stopScanAnimation {
    [self.netView stopAnimation];
}

- (void)drawRect:(CGRect)rect {
    
    CGSize sizeOfRectangle = [[self class] sizeOfRectangleWithFrame:self.frame];
    CGFloat minYOfRectangle = [[self class] minYOfRectangleWithFrame:self.frame];
    CGFloat rectangleMaxY = minYOfRectangle + sizeOfRectangle.height;
    CGFloat rectangleRight = self.frame.size.width - kScanHorizontalOffset;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //非扫码区域半透明
    {
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
        //上
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, minYOfRectangle);
        CGContextFillRect(context, rect);
        //左
        rect = CGRectMake(0, minYOfRectangle, kScanHorizontalOffset, sizeOfRectangle.height);
        CGContextFillRect(context, rect);
        //下
        rect = CGRectMake(0, rectangleMaxY, self.frame.size.width, self.frame.size.height - rectangleMaxY);
        CGContextFillRect(context, rect);
        //右
        rect = CGRectMake(rectangleRight, minYOfRectangle, kScanHorizontalOffset, sizeOfRectangle.height);
        CGContextFillRect(context, rect);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize rectangleSize = [[self class] sizeOfRectangleWithFrame:self.frame];
    CGFloat rectangleMinY = [[self class] minYOfRectangleWithFrame:self.frame];
    
    self.borderView.frame = CGRectMake(kScanHorizontalOffset - 4.5, rectangleMinY - 4.5, rectangleSize.width + 8.5, rectangleSize.height + 8.5);
    self.netView.frame = CGRectMake(kScanHorizontalOffset, rectangleMinY, rectangleSize.width, rectangleSize.height);
    
    
    if (self.showFlashButton) {
        
        CGPoint origin = CGPointMake((self.frame.size.width * 0.5 - self.cardButton.frame.size.width) * 0.5, self.frame.size.height - self.cardButton.frame.size.height - 50.0);
        self.cardButton.frame = (CGRect){origin, self.cardButton.frame.size};
        
        origin = CGPointMake(self.frame.size.width * 0.5 + (self.frame.size.width * 0.5 - self.flashButton.frame.size.width) * 0.5, self.frame.size.height - self.flashButton.frame.size.height - 50.0);
        self.flashButton.frame = (CGRect){origin, self.flashButton.frame.size};
        
    } else {
        
        CGPoint origin = CGPointMake((self.frame.size.width - self.cardButton.frame.size.width) * 0.5, self.frame.size.height - self.cardButton.frame.size.height - 50.0);
        self.cardButton.frame = (CGRect){origin, self.cardButton.frame.size};
    }
}

- (UIImageView *)borderView {
    if (!_borderView) {
        _borderView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"qrcode_border"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)]];
        [self addSubview:_borderView];
    }
    return _borderView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.text = @"将二维码/条形码放到框内，即可自动扫描";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.numberOfLines = 0;
        [self addSubview:_stateLabel];
        
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.borderView);
            make.top.equalTo(self.borderView.mas_bottom).offset(15);
        }];
    }
    return _stateLabel;
}

- (UIButton *)cardButton {
    if (!_cardButton) {
        _cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cardButton setTitle:@"我的名片" forState:UIControlStateNormal];
        _cardButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cardButton setTitleColor:LYMainColor forState:UIControlStateNormal];
        [_cardButton addTarget:self action:@selector(cardButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cardButton sizeToFit];
    }
    return _cardButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setTitle:@"开启闪光灯" forState:UIControlStateNormal];
        [_flashButton setTitle:@"关闭闪光灯" forState:UIControlStateSelected];
        _flashButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_flashButton setTitleColor:LYMainColor forState:UIControlStateNormal];
        [_flashButton addTarget:self action:@selector(flashButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_flashButton sizeToFit];
    }
    return _flashButton;
}


+ (CGSize)sizeOfRectangleWithFrame:(CGRect)frame {
    return CGSizeMake(frame.size.width - 2 * kScanHorizontalOffset, frame.size.width - 2 * kScanHorizontalOffset);
}

+ (CGFloat)minYOfRectangleWithFrame:(CGRect)frame {
    return (frame.size.height - (frame.size.width - 2 * kScanHorizontalOffset)) * 0.5 - kScanCenterUpOffset;
}

+ (CGRect)rectOfInterestForAVCaputreMetadataOutputWithFrame:(CGRect)frame {
    
    CGRect rectOfInterest;
    
    CGSize sizeOfRectangle = [self sizeOfRectangleWithFrame:frame];
    CGFloat minYOfRectangle = [self minYOfRectangleWithFrame:frame];
    CGRect cropRect = CGRectMake(kScanHorizontalOffset, minYOfRectangle, sizeOfRectangle.width, sizeOfRectangle.height);
    
    CGFloat p1 = frame.size.height / frame.size.width;
    CGFloat p2 = 1920.0/1080.0; //使用1080p的图像输出
    
    if (p1 < p2) {
        CGFloat fixHeight = frame.size.width * 1920.0 / 1080.0;
        CGFloat fixPadding = (fixHeight - frame.size.height) * 0.5;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding) / fixHeight,
                                    cropRect.origin.x / frame.size.width,
                                    cropRect.size.height / fixHeight,
                                    cropRect.size.width / frame.size.width);
    } else {
        CGFloat fixWidth = frame.size.height * 1080.0 / 1920.0;
        CGFloat fixPadding = (fixWidth - frame.size.width) * 0.5;
        rectOfInterest = CGRectMake(cropRect.origin.y / frame.size.height,
                                    (cropRect.origin.x + fixPadding) / fixWidth,
                                    cropRect.size.height / frame.size.height,
                                    cropRect.size.width / fixWidth);
    }
    return rectOfInterest;
}

@end
