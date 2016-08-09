//
//  LYComposeRootViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposeRootViewController.h"
#import "LYVerticalButton.h"
#import <pop/POP.h>

#import "LYComposePlainViewController.h"

#define LYComposeStartY kScreen_Height * 5.0 / 13.0
#define LYComposeAnimatingInterval  0.20f

@interface LYComposeRootViewController ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *dayLabel, *weekLabel, *monthLabel, *weatherLabel;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableArray <LYVerticalButton *> *arrayOfButton;

@end

@implementation LYComposeRootViewController

- (instancetype)init {
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)loadView {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.view = [[UIVisualEffectView alloc] initWithEffect:effect];

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:tapGes];
    
    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(turnLeft:)];
    [self.view addGestureRecognizer:swipeGes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDate];

    _arrayOfButton = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger idx = 0; idx < 12; idx ++) {
        [_arrayOfButton addObject:[self createButtonWithIndex:idx]];
    }
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.adjustsImageWhenHighlighted = NO;
    [_cancelButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.frame = CGRectMake(0, kScreen_Height - 44.0, kScreen_Width, 44.0);
    [_cancelButton setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close"] forState:UIControlStateNormal];
    [self.view addSubview:_cancelButton];
}

- (void)setupDate {
 
    self.dayLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:50.0];
        label.textColor = [UIColor colorWithWhite:132.0/255 alpha:1];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(60);
        }];
        label;
    });
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld", [[NSDate date] day]];
    
    self.weekLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithWhite:102.0/255 alpha:1];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLabel.mas_right).offset(10);
            make.top.equalTo(self.dayLabel).offset(10);
        }];
        label;
    });
    self.weekLabel.text = [[NSDate date] weekdayOfChinese];
    
    self.monthLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithWhite:102.0/255 alpha:1];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLabel.mas_right).offset(10);
            make.bottom.equalTo(self.dayLabel).offset(-10);
        }];
        label;
    });
    self.monthLabel.text = [NSString stringWithFormat:@"%02ld/%ld", [[NSDate date] month], [[NSDate date] year]];
    
    self.weekLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13.5];
        label.textColor = [UIColor colorWithWhite:102.0/255 alpha:1];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dayLabel).offset(3);
            make.top.equalTo(self.dayLabel.mas_bottom).offset(5);
        }];
        label;
    });
    self.weekLabel.text = @"佛山：晴 32°C";
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.adjustsImageWhenHighlighted = NO;
        [_backButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [_backButton addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventTouchUpInside];
        _backButton.frame = CGRectMake(0, kScreen_Height - 44.0, kScreen_Width * 0.5 - 1.0, 44.0);
        [_backButton setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_return"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (LYVerticalButton *)createButtonWithIndex:(NSInteger)index {
    NSString *imageName = nil;
    NSString *title = nil;
    switch (index) {
        case 0:
            imageName = @"tabbar_compose_idea";
            title = @"文字";
            break;
        case 1:
            imageName = @"tabbar_compose_photo";
            title = @"照片/视频";
            break;
        case 2:
            imageName = @"tabbar_compose_headlines";
            title = @"头条文章";
            break;
        case 3:
            imageName = @"tabbar_compose_lbs";
            title = @"签到";
            break;
        case 4:
            imageName = @"tabbar_compose_video";
            title = @"直播";
            break;
        case 5:
            imageName = @"tabbar_compose_more";
            title = @"更多";
            break;
        case 6:
            imageName = @"tabbar_compose_review";
            title = @"点评";
            break;
        case 7:
            imageName = @"tabbar_compose_friend";
            title = @"好友圈";
            break;
        case 8:
            imageName = @"tabbar_compose_music";
            title = @"音乐";
            break;
        case 9:
            imageName = @"tabbar_compose_envelope";
            title = @"红包";
            break;
        case 10:
            imageName = @"tabbar_compose_productrelease";
            title = @"红包";
        case 11:
            imageName = @"tabbar_compose_shooting";
            title = @"秒拍";
            break;
    }
    if (!imageName || !title) {
        return nil;
    }
    
    LYVerticalButton *button = [[LYVerticalButton alloc] init];
    button.tag = index;
    
    [button addTarget:self action:@selector(composeClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.beatWhenHighlighted = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    CGFloat leftOffset = 35.0;
    CGFloat buttonWidth = 71.0;
    CGFloat buttonHeight = 100.0;
    CGFloat buttonSpace = (kScreen_Width - 3 * buttonWidth - 2 * leftOffset) * 0.5;
    
    NSInteger idx = index % 6;
    NSInteger page = index / 6;
    NSInteger row = idx / 3;
    NSInteger line = idx % 3;
    
    CGRect fromFrame = CGRectMake(leftOffset + (buttonWidth + buttonSpace) * line + kScreen_Width * page, kScreen_Height + (buttonHeight + 40.0) * row, 71, 100);
    CGRect toFrame = CGRectMake(leftOffset + (buttonWidth + buttonSpace) * line + kScreen_Width * page, (buttonHeight + 40.0) * row + LYComposeStartY, 71, 100);
    
    if (index < 6) {
        button.frame = fromFrame;
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.fromValue = [NSValue valueWithCGRect:fromFrame];
        animation.toValue = [NSValue valueWithCGRect:toFrame];
        animation.springBounciness = 10.0;
        animation.beginTime = CACurrentMediaTime() + 0.1 * row + 0.1 * line;
        [button pop_addAnimation:animation forKey:nil];
    } else {
        button.frame = toFrame;
    }
    
    return button;
}

- (void)composeClick:(UIButton *)sender {
    if (sender.tag == 5) {
        [self turnPage];
    } else {
    
        
        [self dismissWithBlock:^{
            
            switch (sender.tag) {
                case 0:
                {   //文字
                    LYBaseNavigationController *nav = [[LYBaseNavigationController alloc] initWithRootViewController:[LYComposePlainViewController new]];
                    [self.tabBarController presentViewController:nav animated:YES completion:nil];
                }
                    break;
                case 1:
                {   //照片/视频
                    
                }
                    break;
                case 2:
                {   //头条文章
                    
                }
                    break;
                case 3:
                {   //签到
                    
                }
                    break;
                case 4:
                {   //直播
                    
                }
                    break;
                case 6:
                {   //点评
                    
                }
                    break;
                case 7:
                {   //好友圈
                    
                }
                    break;
                case 8:
                {   //音乐
                    
                }
                    break;
                case 9:
                {   //秒拍
                    
                }
                    break;
                case 10:
                {   //红包
                    
                }
                    break;
                case 11:
                {   //商品
                    
                }
                    break;
            }
        }];
    }
}

- (void)turnPage {
    
    LYVerticalButton *lastButton = _arrayOfButton.lastObject;
    if (lastButton.x > kScreen_Width) {
        self.backButton.alpha = 0.0;
        [self.view addSubview:self.backButton];
    }

    [UIView animateWithDuration:0.2 animations:^{
        if (lastButton.x > kScreen_Width) {
            for (UIButton *button in _arrayOfButton) {
                button.x -= kScreen_Width;
            }
            self.backButton.alpha = 1.0;
            self.cancelButton.frame = CGRectMake(kScreen_Width * 0.5, kScreen_Height - 44.0, kScreen_Width * 0.5, 44.0);
            
        } else {
            for (UIButton *button in _arrayOfButton) {
                button.x += kScreen_Width;
            }
            self.backButton.alpha = 0.0;
            self.cancelButton.frame = CGRectMake(0, kScreen_Height - 44.0, kScreen_Width, 44.0);
            
        }
    } completion:^(BOOL finished) {
        if (self.backButton.alpha < 0.2) {
            [self.backButton removeFromSuperview];
        }
    }];
}

- (void)turnLeft:(UISwipeGestureRecognizer *)ges {
    if (ges.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_arrayOfButton.lastObject.x < kScreen_Width) {
            [self turnPage];
        }
    }
}

- (void)dismiss {
    [self dismissWithBlock:nil];
}

- (void)dismissWithBlock:(void (^)())block {
    
    for (NSInteger idx = 0; idx < 6; idx ++) {
        NSInteger index = idx;
        if (_arrayOfButton.lastObject.x < kScreen_Width) {
            index = idx + 6;
        }
        
        NSInteger row = idx % 3;
        NSInteger line = idx / 3;
        
        UIButton *button = _arrayOfButton[index];
        CGRect toFrame = button.frame;
        toFrame.origin.y += (kScreen_Height - LYComposeStartY);
        
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.duration = LYComposeAnimatingInterval;
        animation.fromValue = [NSValue valueWithCGRect:button.frame];
        animation.toValue = [NSValue valueWithCGRect:toFrame];
        animation.beginTime = CACurrentMediaTime() + 0.4 - row * 0.1 - line * 0.1;
        [button pop_addAnimation:animation forKey:nil];
        
        if (idx == 0) {
            [animation setCompletionBlock:^(POPAnimation *ani, BOOL f) {
                [self dismissViewControllerAnimated:NO completion:^{
                    if (block) {
                        block();
                    }
                }];
            }];
        }
    }
}


@end
