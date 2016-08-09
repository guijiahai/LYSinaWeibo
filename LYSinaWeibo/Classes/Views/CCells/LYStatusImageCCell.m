//
//  LYStatusImageCCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/11.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusImageCCell.h"

NSString *const kCCellIdentifier_LYStatusImage = @"LYStatusImageCCell";

@implementation LYStatusImageCCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.canLoadImage = YES;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _gifIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_feed_image_gif"]];
        _gifIcon.hidden = YES;
        [self.contentView addSubview:_gifIcon];
        [_gifIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(_imageView);
        }];
    }
    return self;
}

- (void)setUrl:(NSString *)url {
    _gifIcon.hidden = YES;
    _url = url;
    _url = [url stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"orj480"];
    
    if (self.canLoadImage) {
        ESWeakSelf
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            ESStrongSelf
            strongSelf.gifIcon.hidden = ![imageURL.absoluteString.pathExtension.lowercaseString isEqualToString:@"gif"];
            if (strongSelf.imageDownloadFinished) {
                strongSelf.imageDownloadFinished(image, imageURL.absoluteString);
            }
        }];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end
