//
//  LYShareSheet.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYShareSheet.h"
#import "LYVerticalButton.h"

static CGFloat const kLYShareSheetHeight = 300.0f;
static CGFloat const kSheetButtonWidth = 57.0;
static CGFloat const kSheetButtonHeight = 80.0;
static CGFloat const kSheetButtonSpace = 15.0;

static NSArray *shareItemArray;
static NSArray *actionItemArray;

static NSString *const kNormalImage = @"normalImage";
static NSString *const kHighImage = @"highlightedImage";
static NSString *const kSelectedImage = @"selectedImage";
static NSString *const kTitle = @"title";
static NSString *const kSelectedTitle = @"selectedTitle";

typedef NS_ENUM(NSInteger, LYShareButtonType) {
    LYShareButtonTypePrivateMessage,        //私信和群
    LYShareButtonTypeWeixin,                //微信
    LYShareButtonTypeCircleFriends,         //朋友圈
    LYShareButtonTypeZhifubao,              //支付宝
    LYShareButtonTypeZhifubaoFriend,        //朋友圈
    LYShareButtonTypeQQ,                    //QQ
    LYShareButtonTypeQZone,                 //qzone
    LYShareButtonTypeMMS,                   //短信
    LYShareButtonTypeEmail,                 //邮件
    LYShareButtonTypeDingding,              //钉钉
    LYShareButtonTypeWeibo,                 //微博
    LYShareButtonTypeFriendsCircle,         //好友圈
};

typedef NS_ENUM(NSInteger, LYActionButtonType) {
    LYActionButtonTypeBlacklist,            //黑名单
    LYActionButtonTypeReport,               //举报
    LYActionButtonTypeLink,                 //复制链接
    LYActionButtonTypeBack,                 //返回首页
    LYActionButtonTypeCollection,           //收藏，或取消收藏
    LYActionButtonTypeChangeFont,           //调整字号
    LYActionButtonTypeTopline,              //帮上头条
};

@interface LYShareSheet ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIImageView *separator;

@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;

@property (nonatomic, assign) LYShareSheetStyle style;

@property (nonatomic, strong) NSArray *shareIndexs, *actionIndexs;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@implementation LYShareSheet

+ (void)initialize {
    shareItemArray = @[
                            //0
                             @{kTitle : @"私信和群", kNormalImage : @"more_chat", kHighImage : @"more_chat_highlighted"},
                             //1
                             @{kTitle : @"微信好友", kNormalImage : @"more_weixin", kHighImage : @"more_weixin_highlighted"},
                             //2
                             @{kTitle : @"朋友圈", kNormalImage : @"more_circlefriends", kHighImage : @"more_circlefriends_highlighted"},
                             //3
                             @{kTitle : @"支付宝好友", kNormalImage : @"more_icon_zhifubao", kHighImage : @"more_icon_zhifubao_highlighted"},
                             //4
                             @{kTitle : @"生活圈", kNormalImage : @"more_icon_zhifubao_friend", kHighImage : @"more_icon_zhifubao_friend_highlighted"},
                             //5
                             @{kTitle : @"QQ", kNormalImage : @"more_icon_qq", kHighImage : @"more_icon_qq_highlighted"},
                             //6
                             @{kTitle : @"QQ空间", kNormalImage : @"more_icon_qzone", kHighImage : @"more_icon_qzone_highlighted"},
                             //7
                             @{kTitle : @"短信", kNormalImage : @"more_mms", kHighImage : @"more_mms_highlighted"},
                             //8
                             @{kTitle : @"发送邮件", kNormalImage : @"more_email", kHighImage : @"more_email_highlighted"},
                             //9
                             @{kTitle : @"钉钉", kNormalImage : @"more_icon_dingding", kHighImage : @"more_icon_dingding_highlighted"},
                             //10
                             @{kTitle : @"微博", kNormalImage : @"more_weibo", kHighImage : @"more_weibo_highlighted"},
                             //11
                             @{kTitle : @"好友圈", kNormalImage : @"more_friendscircle", kHighImage : @"more_friendscircle_highlighted"}
                             ];
    
    actionItemArray = @[
                             //0
                             @{kTitle : @"加入黑名单", kNormalImage : @"more_icon_blacklist"},
                             //1
                             @{kTitle : @"举报", kNormalImage : @"more_icon_report"},
                             //2
                             @{kTitle : @"复制链接", kNormalImage : @"more_icon_link"},
                             //3
                             @{kTitle : @"返回首页", kNormalImage : @"more_icon_back"},
                             //4
                             @{kTitle : @"收藏", kSelectedTitle : @"取消收藏", kNormalImage : @"more_icon_collection", kSelectedImage : @"more_icon_collection_highlighted"},
                             //5
                             @{kTitle : @"调整字号", kNormalImage : @"more_icon_change_size"},
                             //6
                             @{kTitle : @"帮上头条", kNormalImage : @"more_icon_topline"}
                             ];
}


- (NSArray *)shareIndexs {
    if (!_shareIndexs) {
        switch (self.style) {
            case LYShareSheetStyleStatusDetail:
                _shareIndexs = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
                break;
            case LYShareSheetStyleWebView:
                
                break;
            case LYShareSheetStyleUserInfo:
                _shareIndexs = @[@10, @11, @0, @1, @2, @3, @4, @5, @6, @9];
                break;
            default:
                break;
        }
    }
    return _shareIndexs;
}

- (NSArray *)actionIndexs {
    if (!_actionIndexs) {
        switch (self.style) {
            case LYShareSheetStyleStatusDetail:
                _actionIndexs = @[@4, @6, @2, @1, @3];
                break;
            case LYShareSheetStyleWebView:
                
                break;
            case LYShareSheetStyleUserInfo:
                _actionIndexs = @[@2, @3];
                break;
        }
    }
    return _actionIndexs;
}

- (instancetype)initWithStyle:(LYShareSheetStyle)style {
    if (self = [super initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 0)]) {
        self.style = style;
        
        self.backgroundColor = [UIColor colorWithWhite:226.0/255 alpha:1];
        
        _backgroundView = [[UIView alloc] initWithFrame:kScreen_Bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _backgroundView.alpha = 0.0;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroundView addGestureRecognizer:tapGes];
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"分享到";
            label.textColor = [UIColor colorWithWhite:108.0/255 alpha:1.0];
            label.font = [UIFont systemFontOfSize:15];
            [self addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.top.equalTo(self).offset(20);
            }];
            label;
        });
        
        _topScrollView = ({
            UIScrollView *sv = [[UIScrollView alloc] init];
            sv.backgroundColor = [UIColor clearColor];
            sv.showsHorizontalScrollIndicator = NO;
            sv.bounces = NO;
            [self addSubview:sv];
            [sv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_titleLabel.mas_bottom).offset(5.0);
                make.height.mas_equalTo(100);
            }];
            sv;
        });
        
        _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_topScrollView.mas_bottom);
            make.height.mas_equalTo(2);
        }];
        
        _bottomScrollView = ({
            UIScrollView *sv = [[UIScrollView alloc] init];
            sv.backgroundColor = [UIColor clearColor];
            sv.showsHorizontalScrollIndicator = NO;
            sv.bounces = NO;
            [self addSubview:sv];
            [sv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(_separator.mas_bottom).offset(8);
                make.height.mas_equalTo(100);
            }];
            sv;
        });
        
        _cancelButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:250.0/255 alpha:1]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:230.0/255 alpha:1]] forState:UIControlStateHighlighted];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithWhite:80.0/255 alpha:1] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bottomScrollView.mas_bottom);
                make.left.right.equalTo(self);
                make.height.mas_equalTo(50);
            }];
            button;
        });
        
        //share
        for (NSInteger idx = 0; idx < self.shareIndexs.count; idx ++) {
            [self createShareButtonWithIndex:idx];
        }
        _topScrollView.contentSize = CGSizeMake((kSheetButtonSpace + kSheetButtonWidth) * self.shareIndexs.count + kSheetButtonSpace, 100.0);
        
        //action
        for (NSInteger idx = 0; idx < self.actionIndexs.count; idx ++) {
            [self createActionButtonWithIndex:idx];
        }
        _bottomScrollView.contentSize = CGSizeMake((kSheetButtonSpace + kSheetButtonWidth) * self.actionIndexs.count + kSheetButtonSpace, 100.0);
    }
    return self;
}

- (void)createShareButtonWithIndex:(NSInteger)index {
    NSInteger tag = [self.shareIndexs[index] integerValue];
    UIButton *button = [LYVerticalButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.frame = CGRectMake(kSheetButtonSpace + (kSheetButtonWidth + kSheetButtonSpace) * index, 5.0, kSheetButtonWidth, kSheetButtonHeight);
    [button setTitle:shareItemArray[tag][kTitle] forState:UIControlStateNormal];
    if (shareItemArray[tag][kNormalImage]) {
        [button setImage:[UIImage imageNamed:shareItemArray[tag][kNormalImage]] forState:UIControlStateNormal];
    }
    if (shareItemArray[tag][kHighImage]) {
        [button setImage:[UIImage imageNamed:shareItemArray[tag][kHighImage]] forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topScrollView addSubview:button];
}

- (void)createActionButtonWithIndex:(NSInteger)index {
    NSInteger tag = [self.actionIndexs[index] integerValue];
    UIButton *button = [LYVerticalButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.frame = CGRectMake(kSheetButtonSpace + (kSheetButtonWidth + kSheetButtonSpace) * index, 0.0, kSheetButtonWidth, kSheetButtonHeight);
    [button setTitle:actionItemArray[tag][kTitle] forState:UIControlStateNormal];
    [button setTitle:actionItemArray[tag][kSelectedTitle] forState:UIControlStateSelected];
    if (actionItemArray[tag][kNormalImage]) {
        [button setImage:[UIImage imageNamed:actionItemArray[tag][kNormalImage]] forState:UIControlStateNormal];
    }
    if (actionItemArray[tag][kSelectedImage]) {
        [button setImage:[UIImage imageNamed:actionItemArray[tag][kSelectedImage]] forState:UIControlStateSelected];
    }
    button.titleEdgeInsets = UIEdgeInsetsMake(30.0, -30, -30, 30);
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomScrollView addSubview:button];
}

- (void)show {
    
    if (self.superview || self.animating) {
        return;
    }
    self.animating = YES;
    
    //设置初始位置
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.height, 0);
    
    CGRect showFrame = CGRectMake(0, kScreen_Height - kLYShareSheetHeight, kScreen_Width, kLYShareSheetHeight);
    self.backgroundView.alpha = 0.0;
    [kKeyWindow addSubview:self.backgroundView];
    [kKeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.frame = showFrame;
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)dismiss {
    [self dismissAnimated:YES];
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


- (void)shareButtonClicked:(UIButton *)sender {
    [self dismiss];
    switch (sender.tag) {
        case LYShareButtonTypePrivateMessage:
            
            break;
        case LYShareButtonTypeWeixin:
            
            break;
        case LYShareButtonTypeCircleFriends:
            
            break;
        case LYShareButtonTypeZhifubao:
            
            break;
        case LYShareButtonTypeZhifubaoFriend:
            
            break;
        case LYShareButtonTypeQQ:
            
            break;
        case LYShareButtonTypeQZone:
            
            break;
        case LYShareButtonTypeMMS:
            
            break;
        case LYShareButtonTypeEmail:
            
            break;
        case LYShareButtonTypeDingding:
            
            break;
        case LYShareButtonTypeWeibo:
            
            break;
        case LYShareButtonTypeFriendsCircle:
            
            break;
    }
}

- (void)actionButtonClicked:(UIButton *)sender {
    [self dismiss];
    switch (sender.tag) {
        case LYActionButtonTypeBlacklist:
            
            break;
        case LYActionButtonTypeReport:
            
            break;
        case LYActionButtonTypeLink:
            
            break;
        case LYActionButtonTypeBack:
            
            break;
        case LYActionButtonTypeCollection:
            
            break;
        case LYActionButtonTypeChangeFont:
            
            break;
        case LYActionButtonTypeTopline:
            
            break;
    }
}

@end
