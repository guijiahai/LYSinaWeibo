//
//  LYAssetCell.m
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/6.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYAssetCell.h"
#import "LYAssetModel.h"

NSString *const kCellIdentifier_Album = @"LYAlbumCell";
NSString *const kCCellIdentifier_Asset = @"LYAssetCCell";
NSString *const kCCellIdentifier_AssetCamera = @"LYAssetCameraCCell";

#pragma mark -
//---------------------------------------------

@interface LYAlbumCell ()

@property (nonatomic, strong) UIImageView *dotView;
@property (nonatomic, strong) UILabel *titleLabel, *countLabel;

@property (nonatomic, assign) PHImageRequestID requestID;
@property (nonatomic, strong) NSString *localIdentifier;

@end

@implementation LYAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
            [self.contentView addSubview:label];
            label;
        });
        
        self.countLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            [self.contentView addSubview:label];
            label;
        });
    }
    return self;
}

- (UIImageView *)dotView {
    if (!_dotView) {
        _dotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_photo_filter_checkbox_checked"]];
        _dotView.hidden = YES;
        [self.imageView addSubview:self.dotView];
    }
    return _dotView;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? [UIColor colorWithWhite:231.0/255 alpha:1] : [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = selected ? [UIColor colorWithWhite:231.0/255 alpha:1] : [UIColor clearColor];
}

- (void)setAlbumModel:(LYAlbumModel *)albumModel {
    _albumModel = albumModel;
    
    self.titleLabel.text = _albumModel.title;
    [self.titleLabel sizeToFit];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)_albumModel.assetModels.count];
    [self.countLabel sizeToFit];
    
    if (_albumModel.hasSelectedAssets) {
        self.dotView.hidden = NO;
    } else {
        if (_dotView) {
            _dotView.hidden = YES;
        }
    }
    
    if (_albumModel.displayImage) {
        self.imageView.image = _albumModel.displayImage;
    } else {
        if (_albumModel.assetModels.count > 0) {
            
            PHAsset *asset = _albumModel.assetModels.firstObject.asset;
            self.localIdentifier = asset.localIdentifier;

            PHImageRequestID requestID = [LYImageManager requestImageForAsset:asset targetSize:CGSizeMake(100, 100) resultHandler:^(UIImage *image, NSDictionary *info, BOOL degraded) {
                if ([self.localIdentifier isEqualToString:asset.localIdentifier]) {
                    if (!degraded) {
                        self.localIdentifier = @"";
                    }
                    albumModel.displayImage = image;
                    self.imageView.image = image;
                }
            }];
            
            if (requestID && self.requestID && requestID != self.requestID) {
                [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
            }
            self.requestID = requestID;
            
        } else {
            _albumModel.displayImage = [UIImage imageNamed:@"photo_filter_image_empty"];
            self.imageView.image = _albumModel.displayImage;
        }
    }
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(10, 5, 50, 50);
    
    if (_dotView) {
        self.dotView.frame = CGRectMake(35, 2, 13, 13);
    }
    
    CGRect titleFrame = CGRectMake(70, ([[self class] cellHeight] - self.titleLabel.bounds.size.height) * 0.5, self.titleLabel.bounds.size.width, self.titleLabel.bounds.size.height);
    self.titleLabel.frame = titleFrame;
    
    CGRect countFrame = CGRectMake(titleFrame.origin.x + titleFrame.size.width + 10.0, titleFrame.origin.y + titleFrame.size.height - self.countLabel.frame.size.height - 2.0, self.countLabel.bounds.size.width, self.countLabel.bounds.size.height);
    self.countLabel.frame = countFrame;
}

+ (CGFloat)cellHeight {
    return 60.0f;
}

@end

#pragma mark -
//---------------------------------------------

@interface LYAssetCCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, assign) PHImageRequestID requestID;
@property (nonatomic, strong) NSString *localIdentifier;

@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation LYAssetCCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectButton setImage:[UIImage imageNamed:@"chooseInterest_uncheaked"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"chooseInterest_cheaked"] forState:UIControlStateSelected];
        self.selectButton.imageEdgeInsets = UIEdgeInsetsMake(-6.5, 6.5, 6.5, -6.5);
        [self.selectButton addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}

- (void)setAssetModel:(LYAssetModel *)assetModel {
    _assetModel = assetModel;
    self.localIdentifier = _assetModel.asset.localIdentifier;
    self.selectButton.selected = _assetModel.isSelected;
    self.showMaskView = _assetModel.isSelected;
    
    CGFloat scale = [LYImageManager imageScale];
    CGSize targetSize = CGSizeMake([LYAssetCCell ccellSize].width * scale, [LYAssetCCell ccellSize].height * scale);
    
    PHImageRequestID requestID = [LYImageManager requestImageForAsset:_assetModel.asset targetSize:targetSize resultHandler:^(UIImage *image, NSDictionary *info, BOOL degraded) {
        
        if ([self.localIdentifier isEqualToString:assetModel.asset.localIdentifier]) {
            if (!degraded) {
                self.localIdentifier = @"";
            }
            self.imageView.image = image;
        }
    }];

    if (requestID && self.requestID && requestID != self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
    }
    self.requestID = requestID;
}

- (void)setShowMaskView:(BOOL)showMaskView {
    _showMaskView = showMaskView;
    if (_showMaskView) {
        [self.contentView.layer insertSublayer:self.maskLayer below:self.selectButton.layer];
    } else {
        if (_maskLayer) {
            [self.maskLayer removeFromSuperlayer];
        }
    }
}

- (CALayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.frame = (CGRect){0, 0, [LYAssetCCell ccellSize]};
        _maskLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4].CGColor;
    }
    return _maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    self.selectButton.frame = CGRectMake(self.contentView.bounds.size.width - 50.0, 0.0, 50.0, 50.0);
}

- (void)selectPhoto {
    if (self.didSelectPhotoHandler) {
        self.didSelectPhotoHandler(self);
    }
}

+ (CGSize)ccellSize {
    CGFloat width;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        width = ([UIScreen mainScreen].bounds.size.width - 12) / 4.0;
    } else {
        width = ([UIScreen mainScreen].bounds.size.width - 8) / 3.0;
    }
    return (CGSize){width, width};
}

@end

#pragma mark -
//---------------------------------------------

@interface LYAssetCameraCCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LYAssetCameraCCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_photo_photograph"] highlightedImage:[UIImage imageNamed:@"compose_photo_photograph_highlighted"]];
        self.imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.imageView];

    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.imageView.highlighted = highlighted;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}


@end