//
//  LYStatusDetailCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailCell.h"
#import "LYCollectionView.h"
#import "TTTAttributedLabel.h"
#import "LYStatus.h"
#import "LYWebViewController.h"
#import "LYStatusImageCCell.h"
#import "MJPhotoBrowser.h"

static NSMutableDictionary *sharedImageSizeDictionary;

NSString *const kCellIdentifier_LYStatusDetail = @"kCellIdentifier_LYStatusDetail";

static CGFloat LYStatusListCell_LeftOffset = 10.0;
static CGFloat LYStatusListCell_TopOffset = 15.0;

@interface LYStatusDetailCell () <TTTAttributedLabelDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *vipIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UIButton *favoriteButton;

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) LYCollectionView *collectionView;

@property (nonatomic, strong) UIButton *retweetBgView;
@property (nonatomic, strong) TTTAttributedLabel *retweetContentLabel;

//以下三个按钮是针对原微博的，如果没有原微博，则隐藏
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *attitudeButton;

@property (nonatomic, strong) UIImageView *lineView;

@end

@implementation LYStatusDetailCell

+ (void)initialize {
    sharedImageSizeDictionary = [NSMutableDictionary dictionary];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = ({
            UIImageView *iv = [[UIImageView alloc] init];
            iv.layer.cornerRadius = 17.0;
            iv.layer.masksToBounds = YES;
            [self.contentView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(34, 34));
                make.left.equalTo(self.contentView).offset(LYStatusListCell_LeftOffset);
                make.top.equalTo(self.contentView).offset(LYStatusListCell_TopOffset);
            }];
            iv;
        });
        
        _vipIcon = ({
            UIImageView *iv = [UIImageView new];
            iv.image = [UIImage imageNamed:@"avatar_vip"];
            [self.contentView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(14, 14));
                make.right.bottom.equalTo(self.iconView).offset(3);
            }];
            iv;
        });
        
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconView.mas_right).offset(15);
                make.top.equalTo(self.contentView).offset(LYStatusListCell_TopOffset);
            }];
            label;
        });
        
        _levelView = [[UIImageView alloc] init];
        [self.contentView addSubview:_levelView];
        [_levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        _fromLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel);
                make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            }];
            label;
        });
        
        _favoriteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"card_icon_favorite"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"card_icon_favorite_highlighted"] forState:UIControlStateSelected];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(24, 24));
                make.right.equalTo(self.contentView).offset(-10);
                make.top.equalTo(self.contentView).offset(15);
            }];
            button;
        });
        
        _contentLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            label.lineSpacing = 2.0;
            label.delegate = self;
            label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            label.font = [UIFont systemFontOfSize:16];
            label.numberOfLines = 0;
            label.linkAttributes = kLinkAttributes;
            label.activeLinkAttributes = kLinkAttributesActive;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(LYStatusListCell_LeftOffset);
                make.right.equalTo(self.contentView).offset(-LYStatusListCell_LeftOffset);
                make.top.equalTo(self.iconView.mas_bottom).offset(10);
            }];
            label;
        });
        
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (LYCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[LYCollectionView alloc] initWithFrame:CGRectMake(10.0, 0, kScreen_Width - 20, 50) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LYStatusImageCCell class] forCellWithReuseIdentifier:kCCellIdentifier_LYStatusImage];
    }
    return _collectionView;
}

- (UIButton *)repostButton {
    if (!_repostButton) {
        _repostButton = [self buttonWithIndex:0];
        [_repostButton setImage:[UIImage imageNamed:@"statusdetail_icon_retweet"] forState:UIControlStateNormal];
        [_repostButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.commentButton.mas_left).offset(-20);
            make.bottom.equalTo(self.retweetBgView).offset(-10);
        }];
    }
    return _repostButton;
}

- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [self buttonWithIndex:1];
        [_commentButton setImage:[UIImage imageNamed:@"statusdetail_icon_comment"] forState:UIControlStateNormal];
        [_commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.attitudeButton.mas_left).offset(-20);
            make.bottom.equalTo(self.retweetBgView).offset(-10);
        }];
    }
    return _commentButton;
}

- (UIButton *)attitudeButton {
    if (!_attitudeButton) {
        _attitudeButton = [self buttonWithIndex:2];
        [_attitudeButton setImage:[UIImage imageNamed:@"statusdetail_icon_like"] forState:UIControlStateNormal];
        [_attitudeButton setImage:[UIImage imageNamed:@"common_praise_light_selected"] forState:UIControlStateSelected];
        [_attitudeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.retweetBgView).offset(-17);
            make.bottom.equalTo(self.retweetBgView).offset(-10);
        }];
    }
    return _attitudeButton;
}

//button
- (UIButton *)buttonWithIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.retweetBgView addSubview:button];
    return button;
}

- (void)setCurrentStatus:(LYStatus *)currentStatus {
    _currentStatus = currentStatus;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_currentStatus.user.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    
    _vipIcon.hidden = !_currentStatus.user.verified;
    if (_currentStatus.user.verified) {
        NSString *imageName = nil;
        switch (_currentStatus.user.verified_type.integerValue) {
            case 0:
                imageName = @"avatar_vip";
                break;
            case 2:
            case 3:
            case 5:
                imageName = @"avatar_enterprise_vip";
                break;
            case 220:
                imageName = @"avatar_grassroot";
                break;
            default:
                break;
        }
        _vipIcon.image = imageName == nil ? nil : [UIImage imageNamed:imageName];
    }
    
    _nameLabel.text = _currentStatus.user.screen_name;
    _nameLabel.textColor = _currentStatus.user.mbrank.integerValue > 0 ? LYMainColor : [UIColor colorWithWhite:34.0/255 alpha:1];
    
    _levelView.hidden = _currentStatus.user.mbrank.integerValue <= 0;
    if (currentStatus.user.mbrank.integerValue > 0) {
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%@", currentStatus.user.mbrank.stringValue];
        _levelView.image = [UIImage imageNamed:imageName];
    }
    
    _fromLabel.text = [NSString stringWithFormat:@"%@  %@", [[self.currentStatus.created_at systemDate] stringDisplay_HHmm], self.currentStatus.source ?: @""];
    
    _favoriteButton.selected = _currentStatus.favorited;
    
    _contentLabel.text = _currentStatus.text;
    for (NSTextCheckingResult *check in self.currentStatus.items) {
        NSLog(@"%@ %@", _currentStatus.text, NSStringFromRange(check.range));
        [_contentLabel addLinkToTransitInformation:@{@"value" : check, @"text" : _currentStatus.text} withRange:check.range];
    }

    //原微博
    if (_currentStatus.retweeted_status) {
        LYStatus *retweetedStatus = _currentStatus.retweeted_status;
        [self.retweetBgView setHidden:NO];
        
        NSString *contentText = retweetedStatus.text ?: @"";
        contentText = [NSString stringWithFormat:@"@%@ :%@", retweetedStatus.user.screen_name, contentText];
        self.retweetContentLabel.text = contentText;
        for (NSTextCheckingResult *check in retweetedStatus.items) {
            [self.retweetContentLabel addLinkToTransitInformation:@{@"value" : check, @"text" : contentText} withRange:check.range];
        }
    } else {
        if (_retweetBgView) {
            [self.retweetBgView setHidden:YES];
        }
    }
    
    //一个微博不会同时存在两个collectionView
    if (_currentStatus.pic_urls.count > 0) {
        if (self.collectionView.superview != self.contentView) {
            [self.collectionView removeFromSuperview];
            [self.contentView addSubview:self.collectionView];
        }
        CGFloat height = [[self class] collectionHeightWithPicUrls:_currentStatus.pic_urls];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10.0);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(height);
        }];
        [self.collectionView setHidden:NO];
        [self.collectionView reloadData];
    } else if (_currentStatus.retweeted_status.pic_urls.count > 0) {
        if (self.collectionView.superview != self.retweetBgView) {
            [self.collectionView removeFromSuperview];
            [self.retweetBgView addSubview:self.collectionView];
        }
        CGFloat height = [[self class] collectionHeightWithPicUrls:_currentStatus.retweeted_status.pic_urls];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.retweetContentLabel.mas_bottom).offset(10);
            make.left.equalTo(self.retweetBgView).offset(10);
            make.right.equalTo(self.retweetBgView).offset(-10);
            make.height.mas_equalTo(height);
        }];
        [self.collectionView setHidden:NO];
        [self.collectionView reloadData];
    } else {
        if (_collectionView) {
            [self.collectionView setHidden:YES];
        }
    }
    
    if (self.currentStatus.retweeted_status) {
        [self.attitudeButton setTitle:_currentStatus.reposts_count.stringValue forState:UIControlStateNormal];
        [self.commentButton setTitle:_currentStatus.comments_count.stringValue forState:UIControlStateNormal];
        [self.repostButton setTitle:_currentStatus.reposts_count.stringValue forState:UIControlStateNormal];
    }
}

- (UIView *)retweetBgView {
    if (!_retweetBgView) {
        _retweetBgView = [[UIButton alloc] init];
        [_retweetBgView addTarget:self action:@selector(showRetweetStatus) forControlEvents:UIControlEventTouchUpInside];
        [_retweetBgView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:247.0/255 alpha:1]] forState:UIControlStateNormal];
        [_retweetBgView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:237.0/255 alpha:1]] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_retweetBgView];
        [_retweetBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        }];
    }
    return _retweetBgView;
}

- (TTTAttributedLabel *)retweetContentLabel {
    if (!_retweetContentLabel) {
        _retweetContentLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            label.lineSpacing = 2.0;
            label.backgroundColor = [UIColor clearColor];
            label.delegate = self;
            label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            label.linkAttributes = kLinkAttributes;
            label.activeLinkAttributes = kLinkAttributesActive;
            [self.retweetBgView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_retweetBgView).offset(LYStatusListCell_LeftOffset);
                make.right.equalTo(_retweetBgView).offset(-LYStatusListCell_LeftOffset);
                make.top.equalTo(_retweetBgView).offset(10);
            }];
            label;
        });
    }
    return _retweetContentLabel;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (url) {
        LYWebViewController *webVC = [[LYWebViewController alloc] init];
        webVC.URL = url;
        [[self viewController].navigationController pushViewController:webVC animated:YES];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    NSString *text = components[@"text"];
    NSTextCheckingResult *result = components[@"value"];
    NSString *comp = [text substringWithRange:result.range];
    NSLog(@"%@", comp);
}

#pragma mark - collection view methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    LYStatus *status = self.currentStatus.retweeted_status ?: self.currentStatus;
    return status.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYStatusImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_LYStatusImage forIndexPath:indexPath];
    if (self.currentStatus.retweeted_status) {
        cell.url = self.currentStatus.retweeted_status.pic_urls[indexPath.row][@"thumbnail_pic"];
    } else {
        cell.url = self.currentStatus.pic_urls[indexPath.row][@"thumbnail_pic"];
    }
    ESWeakSelf
    cell.imageDownloadFinished = ^(UIImage *image, NSString *url) {
        ESStrongSelf
        NSString *lastPathComponent = [url lastPathComponent];
        //判断图片是currentStatus还是retweetStatus
        LYStatus *status = self.currentStatus.retweeted_status ?: self.currentStatus;
        if (status.pic_urls.count == 1 && [lastPathComponent isEqualToString:[status.pic_urls.firstObject[@"thumbnail_pic"] lastPathComponent]]) {
            //使用sharedImageSizeDictionary，防止死循环
            if (!sharedImageSizeDictionary[lastPathComponent]) {
                NSValue *value = [NSValue valueWithCGSize:image.size];
                sharedImageSizeDictionary[lastPathComponent] = value;
                [strongSelf.tableView reloadData];
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    LYStatus *status = self.currentStatus.retweeted_status ?: self.currentStatus;
    
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger idx = 0; idx < status.pic_urls.count; idx ++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *url = [status.pic_urls[idx][@"thumbnail_pic"] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
        photo.url = [NSURL URLWithString:url];
        NSIndexPath *ip = [NSIndexPath indexPathForItem:idx inSection:0];
        LYStatusImageCCell *ccell = (LYStatusImageCCell *)[collectionView cellForItemAtIndexPath:ip];
        photo.srcImageView = ccell.imageView;
        [photos addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = photos;
    browser.currentPhotoIndex = indexPath.item;
    [browser showInViewController:[self viewController]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYStatus *status = self.currentStatus.retweeted_status ?: self.currentStatus;
    if (status.pic_urls.count == 1) {
        NSValue *value = sharedImageSizeDictionary[[status.pic_urls.firstObject[@"thumbnail_pic"] lastPathComponent]];
        CGSize size = CGSizeZero;
        if (value) {
            size = [value CGSizeValue];
        }
        return [[self class] recalculateImageSize:size count:1];
    } else {
        return [[self class] recalculateImageSize:CGSizeZero count:status.pic_urls.count];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}


- (CGSize)recalculateSize:(CGSize)originalSize {
    CGFloat maxWidth = kScreen_Width * 0.6;
    
    CGSize reSize = CGSizeZero;
    
    CGFloat sw = originalSize.width / maxWidth;
    CGFloat sh = originalSize.height / maxWidth;
    
    if (sh / sw >= 2.0) {
        //竖长图
        reSize = CGSizeMake(MIN(kScreen_Width * 0.45, originalSize.width), MIN(maxWidth, originalSize.height));
    } else if (sw / sh >= 2.0) {
        //横长图
        reSize = CGSizeMake(MIN(maxWidth, originalSize.width), MIN(kScreen_Width * 0.45, originalSize.height));
    } else {
        if (originalSize.width <= maxWidth && originalSize.height <= maxWidth) {
            reSize = originalSize;
        } else if (originalSize.width > maxWidth && originalSize.height <= maxWidth) {
            reSize = CGSizeMake(maxWidth, originalSize.height);
        } else if (originalSize.width <= maxWidth && originalSize.height > maxWidth) {
            reSize = CGSizeMake(originalSize.width, maxWidth);
        } else {
            reSize = CGSizeMake(originalSize.width / MAX(sw, sh), originalSize.height / MAX(sw, sh));
        }
    }
    
    return reSize;
}

- (void)showRetweetStatus {
    if (self.showRetweetedStatus) {
        self.showRetweetedStatus(self.currentStatus.retweeted_status);
    }
}

+ (CGSize)recalculateImageSize:(CGSize)size count:(NSInteger)count {
    if (count <= 0) {
        return CGSizeZero;
    } else if (count == 1) {
        CGSize reSize = CGSizeZero;
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            return CGSizeMake((kScreen_Width - 30.0) / 3.0, (kScreen_Width - 30.0) / 3.0);
        }
        if (size.width <= kScreen_Width - 20.0) {
            reSize = size;
        } else {
            CGFloat scale = size.width / (kScreen_Width - 20);
            reSize = CGSizeMake(kScreen_Width - 20, size.height / scale);
        }
        return reSize;
    } else if (count == 2 || count == 4) {
        return CGSizeMake((kScreen_Width - 25.0) / 2.0, (kScreen_Width - 25.0) / 2.0);
    } else {
        return CGSizeMake((kScreen_Width - 30.0) / 3.0, (kScreen_Width - 30.0) / 3.0);
    }
}

+ (CGFloat)collectionHeightWithPicUrls:(NSArray *)urls {
    if (urls.count == 1) {
        NSValue *value = sharedImageSizeDictionary[[urls.firstObject[@"thumbnail_pic"] lastPathComponent]];
        CGSize size = CGSizeZero;
        if (value) {
            size = [value CGSizeValue];
        }
        return [self recalculateImageSize:size count:1].height;
    } else if (urls.count > 1) {
        NSInteger row = (urls.count + 2) / 3;
        return ([self recalculateImageSize:CGSizeZero count:urls.count].height + 5) * row - 5;
    }
    return 0.0;
}

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status {
    CGFloat cellHeight = 49.0;  //header
    
    cellHeight += 10.0 + [status.text boundingHeightWithFont:[UIFont systemFontOfSize:16] size:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX) lineSpacing:2.0] + 10.0;
    
    if (status.pic_urls.count > 0) {
        cellHeight += [self collectionHeightWithPicUrls:status.pic_urls];
        cellHeight += 10.0;
    }
    
    if (status.retweeted_status) {
        LYStatus *sta = status.retweeted_status;
        
        cellHeight += 10.0;
        NSString *contentText = [NSString stringWithFormat:@"%@ :%@", sta.user.screen_name, sta.text ?: @""];
        cellHeight += [contentText boundingHeightWithFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreen_Width - 20.0, CGFLOAT_MAX) lineSpacing:2.0];
        cellHeight += 10.0;
        
        if (sta.pic_urls.count > 0) {
            cellHeight += [self collectionHeightWithPicUrls:sta.pic_urls];
            cellHeight += 10.0;
        }
        
        //原微博下面有三个按钮
        cellHeight += 26.0;
        
        cellHeight += 1.0;
    }
    
    return cellHeight;
}

@end
