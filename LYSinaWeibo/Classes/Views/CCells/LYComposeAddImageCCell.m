//
//  LYComposeAddImageCCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposeAddImageCCell.h"

NSString *const kCCellIdentifier_ComposeAddImage = @"LYComposeAddImageCCell";

@interface LYComposeAddImageCCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LYComposeAddImageCCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_pic_add"] highlightedImage:[UIImage imageNamed:@"compose_pic_add_highlighted"]];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.imageView.highlighted = highlighted;
}

+ (CGSize)ccellSize {
    return CGSizeMake(94.0, 94.0);
}

@end
