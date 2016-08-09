//
//  LYComposeKeyboardToolBar.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/3.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposeKeyboardToolBar.h"

#define kLYComposeKeyboardBlueColor [UIColor colorWithRed:86.0/255 green:116.0/255 blue:148.0/255 alpha:1.0]

@interface LYComposeKeyboardToolBar ()

@property (nonatomic, strong) UIButton *locateBtn, *scopeBtn;

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *pictureBtn, *atBtn, *topicBtn, *faceBtn, *moreBtn;
@property (nonatomic, strong) UIImageView *splitView;

@end

@implementation LYComposeKeyboardToolBar

- (instancetype)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        self.backgroundColor = [UIColor whiteColor];

        ;        self.toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 36, kScreen_Width, 44)];
        self.toolBar.backgroundColor = [UIColor colorWithWhite:249.0/255 alpha:1];
        [self addSubview:self.toolBar];
        
        self.splitView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.toolBar addSubview:self.splitView];
        [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.toolBar);
            make.height.mas_equalTo(1);
        }];
        
        self.pictureBtn = [self toolButtonWithIndex:0 imageName:@"compose_toolbar_picture" highlightedImageName:@"compose_toolbar_picture_highlighted" andSelector:@selector(pictureBtnClicked:)];
        [self.toolBar addSubview:self.pictureBtn];
        
        self.atBtn = [self toolButtonWithIndex:1 imageName:@"compose_mentionbutton_background" highlightedImageName:@"compose_mentionbutton_background_highlighted" andSelector:@selector(atBtnClicked:)];
        [self.toolBar addSubview:self.atBtn];
        
        self.topicBtn = [self toolButtonWithIndex:2 imageName:@"compose_trendbutton_background" highlightedImageName:@"compose_trendbutton_background_highlighted" andSelector:@selector(topicBtnClicked:)];
        [self.toolBar addSubview:self.topicBtn];
        
        self.faceBtn = [self toolButtonWithIndex:3 imageName:@"compose_emoticonbutton_background" highlightedImageName:@"compose_emoticonbutton_background_highlighted" andSelector:@selector(faceBtnClicked:)];
        [self.toolBar addSubview:self.faceBtn];
        
        self.moreBtn = [self toolButtonWithIndex:4 imageName:@"compose_toolbar_more" highlightedImageName:@"compose_toolbar_more_highlighted" andSelector:@selector(moreBtnClicked:)];
        [self.toolBar addSubview:self.moreBtn];
        
        [self locateBtn];
        [self scopeBtn];
    }
    return self;
}

- (UIButton *)locateBtn {
    if (!_locateBtn) {  //28* 26
        _locateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _locateBtn.adjustsImageWhenHighlighted = NO;
        [_locateBtn setBackgroundImage:[[UIImage imageNamed:@"compose_author_default"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 12, 13, 12)] forState:UIControlStateNormal];
        [_locateBtn setBackgroundImage:[[UIImage imageNamed:@"compose_author_default_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 12, 13, 12)] forState:UIControlStateHighlighted];
        [_locateBtn setImage:[UIImage imageNamed:@"compose_locatebutton_ready"] forState:UIControlStateNormal];
        [_locateBtn setTitle:@"显示位置" forState:UIControlStateNormal];
        [_locateBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _locateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9);
        _locateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        [_locateBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_locateBtn];
        [_locateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(4);
            make.height.mas_equalTo(26);
        }];
    }
    return _locateBtn;
}

- (UIButton *)scopeBtn {
    if (!_scopeBtn) {
        _scopeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scopeBtn.adjustsImageWhenHighlighted = NO;
        [_scopeBtn setBackgroundImage:[[UIImage imageNamed:@"compose_author_default"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 12, 13, 12)] forState:UIControlStateNormal];
        [_scopeBtn setBackgroundImage:[[UIImage imageNamed:@"compose_author_default_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 12, 13, 12)] forState:UIControlStateHighlighted];
        [_scopeBtn setImage:[UIImage imageNamed:@"compose_publicbutton"] forState:UIControlStateNormal];
        [_scopeBtn setTitle:@"公开" forState:UIControlStateNormal];
        [_scopeBtn setTitleColor:kLYComposeKeyboardBlueColor forState:UIControlStateNormal];
        _scopeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 9);
        _scopeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        _scopeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        [_scopeBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_scopeBtn];
        [_scopeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(4);
            make.height.mas_equalTo(26);
        }];
    }
    return nil;
}

- (UIButton *)toolButtonWithIndex:(NSInteger)index imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName andSelector:(SEL)aSelector {
    CGFloat buttonWidth = kScreen_Width / 5.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonWidth * index, 0, buttonWidth, 44.0);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    [button addTarget:self action:aSelector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)showInWindow {
    self.frame = CGRectMake(0, kScreen_Height - 80.0, kScreen_Width, 80);
    [kKeyWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval interval = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect barFrame = CGRectMake(0, endFrame.origin.y - 80.0, kScreen_Width, 80);
    
    [UIView animateWithDuration:interval delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.frame = barFrame;
    } completion:nil];
}

- (void)pictureBtnClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(composeKeyboardToolBarDidClickPictureButton:)]) {
        [self.delegate composeKeyboardToolBarDidClickPictureButton:self];
    }
}

- (void)atBtnClicked:(UIButton *)sender {
    
}

- (void)topicBtnClicked:(UIButton *)sender {
    
}

- (void)faceBtnClicked:(UIButton *)sender {
    
}

- (void)moreBtnClicked:(UIButton *)sender {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
