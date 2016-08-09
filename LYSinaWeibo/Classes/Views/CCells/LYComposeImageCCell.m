//
//  LYComposeImageCCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposeImageCCell.h"

NSString *const kCCellIdentifier_ComposeImage = @"LYComposeImageCCell";

@interface LYComposeImageCCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation LYComposeImageCCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];

        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setImage:[UIImage imageNamed:@"compose_photo_close"] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
    }
    return self;
}

- (void)deleteClicked {
    if (self.deleteImageBlock) {
        self.deleteImageBlock(self);
    }
}

+ (CGSize)ccellSize {
    CGFloat width;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        width = (kScreen_Width - 10 * 2 - 4 * 3) / 4.0;
    } else {
        width = (kScreen_Width - 10 * 2 - 4 * 2) / 3.0;
    }
    return CGSizeMake(width, width);
}

@end
