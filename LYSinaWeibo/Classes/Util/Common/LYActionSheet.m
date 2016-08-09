//
//  LYActionSheet.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/12.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYActionSheet.h"
#import "AppDelegate.h"

static CGFloat const kLYActionSheetButtonHeight = 50.0f;

typedef void(^animations)();

@interface LYActionSheet ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *destructiveButtonTitle;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleBgView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *destructiveButton;
@property (nonatomic, strong) NSMutableArray <UIButton *> *otherButtons;

@property (nonatomic, assign) BOOL animating;

@end

@implementation LYActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LYActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    
    if (self = [super initWithFrame:CGRectZero]) {
        
        self.backgroundColor = [UIColor colorWithWhite:226.0/255 alpha:1];
        
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.50];
        _backgroundView.alpha = 0.0;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroundView addGestureRecognizer:tapGes];
        
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;
        self.animating = NO;
        
        self.delegate = delegate;
    
        self.otherButtonTitles = [NSMutableArray array];
        self.otherButtons = [NSMutableArray array];
        
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [self.otherButtonTitles addObject:otherButtonTitles];
            NSString *string = nil;
            while ((string = va_arg(args, NSString *))) {
                [self.otherButtonTitles addObject:string];
            }
        }
        va_end(args);
    }
    return self;
}

- (CGFloat)sheetHeightAfterSetup {
    
    //title
    CGFloat curY = 0.0f;
    if (self.title) {
        self.titleLabel.text = self.title;
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - size.width) * 0.5, (kLYActionSheetButtonHeight - size.height) * 0.5, size.width, size.height);
        
        self.titleBgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kLYActionSheetButtonHeight - 1);
        
        if (!self.titleLabel.superview) {
            [self addSubview:self.titleBgView];
            [self addSubview:self.titleLabel];
        }
        
        curY += kLYActionSheetButtonHeight;

    } else {
        if (_titleLabel && _titleLabel.superview) {
            [self.titleLabel removeFromSuperview];
            [self.titleBgView removeFromSuperview];
        }
    }
    
    NSInteger tag = 0;
    //255 59 48
    
    if (self.destructiveButtonTitle) {
        if (!self.destructiveButton) {
            self.destructiveButton = [self createTitleButton];
            [self addSubview:self.destructiveButton];
            [self.destructiveButton setTitleColor:[UIColor colorWithRed:255.0/255 green:59.0/255 blue:48.0/255 alpha:1] forState:UIControlStateNormal];
        }
        self.destructiveButton.tag = tag;
        [self.destructiveButton setTitle:self.destructiveButtonTitle forState:UIControlStateNormal];
        self.destructiveButton.frame = CGRectMake(0, curY, [UIScreen mainScreen].bounds.size.width, kLYActionSheetButtonHeight - 1);
        curY += kLYActionSheetButtonHeight;
        tag ++;
        
    }
    
    
    //other buttons
    NSInteger diff = self.otherButtonTitles.count - self.otherButtons.count;
    for (NSInteger idx = 0; idx < diff; idx ++) {
        UIButton *other = [self createTitleButton];
        [self addSubview:other];
        [self.otherButtons addObject:other];
    }
    for (NSInteger idx = 0; idx < self.otherButtons.count; idx ++) {
        UIButton *other = self.otherButtons[idx];
        other.frame = CGRectMake(0, curY + kLYActionSheetButtonHeight * idx, [UIScreen mainScreen].bounds.size.width, kLYActionSheetButtonHeight - 1);
        other.tag = tag;
        [other setTitle:self.otherButtonTitles[idx] forState:UIControlStateNormal];
        tag ++;
    }
    curY += self.otherButtonTitles.count * kLYActionSheetButtonHeight;
    
    
    // cancel button
    if (self.cancelButtonTitle) {
        if (!self.cancelButton) {
            self.cancelButton = [self createTitleButton];
            [self addSubview:self.cancelButton];
        }
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(0, curY + 5, [UIScreen mainScreen].bounds.size.width, kLYActionSheetButtonHeight);
        self.cancelButton.tag = tag;
        curY += kLYActionSheetButtonHeight + 5; //5为分割线
    }
    return curY;
}

- (UIButton *)createTitleButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:251.0/255 alpha:1]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:231.0/255 alpha:1]] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button setTitleColor:[UIColor colorWithWhite:65.0/255 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:11];
//        _titleLabel.numberOfLines = 1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _titleBgView = [[UIView alloc] init];
        _titleBgView.backgroundColor = [UIColor colorWithWhite:251.0/255 alpha:1];
    }
    return _titleLabel;
}

- (NSInteger)numberOfButtons {
    return self.otherButtonTitles.count + (self.cancelButtonTitle != nil ? 1 : 0);
}

- (NSInteger)cancelButtonIndex {
    if (self.cancelButtonTitle) {
        return self.otherButtonTitles.count;
    }
    return -1;
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    [self.otherButtonTitles addObject:title];
    return self.otherButtonTitles.count - 1;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)index {
    if (index >= 0 || index < self.otherButtonTitles.count) {
        return self.otherButtonTitles[index];
    } else if (index == 0 && self.cancelButtonTitle) {
        return self.cancelButtonTitle;
    }
    return nil;
}

- (void)show {
    
    if (self.superview || self.animating) {
        return;
    }

    self.animating = YES;
    
    CGFloat sheetHeight = [self sheetHeightAfterSetup];
    
    UIWindow *window = [(AppDelegate *)[UIApplication sharedApplication].delegate window];
    CGRect showFrame = [UIScreen mainScreen].bounds;
    showFrame.origin.y = showFrame.size.height - sheetHeight;
    showFrame.size.height = sheetHeight;

    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height, 0);
    
    self.backgroundView.alpha = 0.0;
    [window addSubview:self.backgroundView];
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.frame = showFrame;
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}


- (void)dismissAnimated:(BOOL)animated {
    if (!self.superview || self.animating) {
        return;
    }
    self.animating = YES;

    void (^animations)() = ^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
        self.backgroundView.alpha = 0.0;
    };
    void (^completion)(BOOL) = ^(BOOL finished){
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        self.animating = NO;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [self clickedButtonIndex:buttonIndex];
    [self dismissAnimated:animated];
}

- (void)buttonClicked:(UIButton *)button {
    [self clickedButtonIndex:button.tag];
}

- (void)clickedButtonIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:index];
    }
    [self dismissAnimated:YES];
}

@end
