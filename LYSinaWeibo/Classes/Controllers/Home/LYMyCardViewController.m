//
//  LYMyCardViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/11.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYMyCardViewController.h"
#import "LYShareSheet.h"

@interface LYMyCardViewController ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *QRCodeView, *iconView;
@property (nonatomic, strong) UIView *leftLine, *rightLine;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation LYMyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LYBackgroundColor;
    self.navigationItem.title = @"我的名片";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_more"] hightlightedImage:[UIImage imageNamed:@"navigationbar_more_highlighted"] target:self action:@selector(moreClicked)];
    
    
    self.bgView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5.0;
        view.layer.masksToBounds = YES;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(25);
            make.left.equalTo(self.view).offset(50);
            make.right.equalTo(self.view).offset(-50);
            make.bottom.equalTo(self.view).offset(-170);
        }];
        view;
    });
    
    self.QRCodeView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(80);
            make.centerX.equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        imageView;
    });
    
    self.iconView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.QRCodeView.mas_bottom).offset(90);
            make.centerX.equalTo(self.bgView);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        imageView;
    });
    
    self.leftLine = ({
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:217.0/255 alpha:1];
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(15);
            make.right.equalTo(self.iconView.mas_left).offset(-20);
            make.centerY.equalTo(self.iconView);
            make.height.mas_equalTo(1);
        }];
        line;
    });
    
    self.rightLine = ({
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:217.0/255 alpha:1];
        [self.view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(20);
            make.right.equalTo(self.bgView).offset(-15);
            make.centerY.equalTo(self.iconView);
            make.height.mas_equalTo(1);
        }];
        line;
    });
    
    self.nameLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
        label.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(15);
            make.centerX.equalTo(self.iconView);
        }];
        label;
    });
    
    self.stateLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"扫一扫二维码图案，关注我吧";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.iconView);
        }];
        label;
    });

    [self setupData];
}

//http://weibo.cn/qr/userinfo?uid=5238713487

- (void)setupData {
    ESWeakSelf
    dispatch_async_inChild(^{
        NSString *message = [NSString stringWithFormat:@"http://weibo.cn/qr/userinfo?uid=%@", [LYLogin sharedLogin].uid];
        UIImage *image = [UIImage QRCodeWithInputMessage:message size:CGSizeMake(100, 100)];
        dispatch_async_inMain(^{
            ESStrongSelf
            strongSelf.QRCodeView.image = image;
        });
    });
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[LYLogin sharedLogin].currentUser.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    self.nameLabel.text = [LYLogin sharedLogin].currentUser.screen_name;
}

- (void)moreClicked {
    LYShareSheet *sheet = [[LYShareSheet alloc] initWithStyle:LYShareSheetStyleUserInfo];
    [sheet show];
}

@end
