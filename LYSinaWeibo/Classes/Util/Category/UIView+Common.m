//
//  UIView+Common.m
//  百思不得姐
//
//  Created by GuiJiahai on 16/5/19.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (UIViewController *)viewController {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (BOOL)isShowingInKeyWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window && [UIApplication sharedApplication].windows.count > 0) {
        window = [UIApplication sharedApplication].windows[0];
    }
    CGRect newFrame = [window convertRect:self.frame fromView:self.superview];
    BOOL intersects = CGRectIntersectsRect(newFrame, window.bounds);
    return !self.isHidden && self.alpha > 0.001 && self.window == kKeyWindow && intersects;
}

@end


@implementation UIView (Frame)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setTop:(CGFloat)top {
    [self setY:top];
}

- (CGFloat)top {
    return self.y;
}

- (void)setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}

- (CGFloat)bottom {
    return self.y + self.height;
}

- (void)setLeft:(CGFloat)left {
    self.x = left;
}

- (CGFloat)left {
    return self.x;
}

- (void)setRight:(CGFloat)right {
    self.x = right - self.width;
}

- (CGFloat)right {
    return self.x + self.width;
}

- (CGFloat)maxXOfFrame {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxYOfFrame {
    return CGRectGetMaxY(self.frame);
}

@end

@implementation UITableViewCell (Common)

- (UITableView *)tableView {
    UIView *view = [self superview];
    while (![view isKindOfClass:[UITableView class]] && view) {
        view = [view superview];
    }
    return (UITableView *)view;
}

@end

@interface EaseBlankPageView : UIView

@property (nonatomic, strong) UIImageView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, assign) EaseBlankPageType type;
@property (nonatomic, copy) void(^reloadBlock)();

- (void)configWithType:(EaseBlankPageType)type blank:(BOOL)blank error:(BOOL)error reloadBlock:(void (^)())block;

@end

@implementation EaseBlankPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)configWithType:(EaseBlankPageType)type blank:(BOOL)blank error:(BOOL)error reloadBlock:(void (^)())block {
    _reloadBlock = nil;
    if (!blank) {
        return;
    }
    
    if (!_tipView) {
        _tipView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_tipView];
    }
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_tipLabel];
    }
    
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-80);
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self);
        make.top.equalTo(_tipView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    if (error) {
        //网络出错
        if (!_reloadButton) {
            _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_reloadButton setBackgroundImage:[[UIImage imageNamed:@"common_button_reloading"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
            [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
            [_reloadButton setTitleColor:[UIColor colorWithWhite:102.0/255 alpha:1] forState:UIControlStateNormal];
            _reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [_reloadButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_reloadButton];
            [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(_tipLabel.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(190, 42));
            }];
        }
        _reloadButton.hidden = NO;
        self.reloadBlock = block;
        [_tipView setImage:[UIImage imageNamed:@"empty_failed"]];
        _tipLabel.text = @"网络出错了，请点击按钮重新加载";
        
    } else {
        if (_reloadButton) {
            _reloadButton.hidden = YES;
        }
        
        NSString *imageName, *tipString;
        _type = type;
        switch (_type) {
            case EaseBlankPageTypeCommentAtMe:
                imageName = @"empty_at";
                tipString = @"还没有人在评论中@提到你";
                break;
            case EaseBlankPageTypeStatusAtMe:
                imageName = @"empty_at";
                tipString = @"还没有人在微博中@提到你";
                break;
            case EaseBlankPageTypeProfile:
                tipString = @"数据加载失败，请重试";
                break;
            case EaseBlankPageTypeDefault:
                imageName = @"empty_default";
                tipString = @"这里还没有内容";
            default:
                break;
        }
        [_tipView setImage:[UIImage imageNamed:imageName]];
        _tipLabel.text = tipString;
    }
}

- (void)reloadButtonClick:(id)sender {
    if (_reloadBlock) {
        _reloadBlock();
    }
}

@end

static void const* EaseBlankPageKey = &EaseBlankPageKey;

@implementation UIView (EaseBlankPage)

- (EaseBlankPageView *)blankPageView {
    return objc_getAssociatedObject(self, EaseBlankPageKey);
}

- (void)setBlankPageView:(EaseBlankPageView *)blankPageView {
    objc_setAssociatedObject(self, EaseBlankPageKey, blankPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)configWithType:(EaseBlankPageType)type blank:(BOOL)blank error:(BOOL)error reloadBlock:(void (^)())block {
    if (blank) {
        if (![self blankPageView]) {
            EaseBlankPageView *blanView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
            [self setBlankPageView:blanView];
        }
        [[self blankPageView] setHidden:NO];
        [[self _blankPageContainer] addSubview:[self blankPageView]];
        [[self blankPageView] configWithType:type blank:blank error:error reloadBlock:block];
        
    } else {
        if ([self blankPageView]) {
            [[self blankPageView] setHidden:YES];
            [[self blankPageView] removeFromSuperview];
        }
    }
}

- (UIView *)_blankPageContainer {
    UIView *blankPageContainer = self;
    for (UIView *aView in self.subviews) {
        if ([aView isKindOfClass:[UITableView class]]) {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}

@end