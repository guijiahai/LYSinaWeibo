//
//  LYStatusAtMeCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/17.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusAtMeCell.h"
#import "LYStatus.h"
#import "LYWebViewController.h"
#import "TTTAttributedLabel.h"
#import "LYCollectionView.h"
#import "LYStatusImageCCell.h"
#import "MJPhotoBrowser.h"

NSString *const kCellIdentifier_StatusAtMe = @"LYStatusAtMeCell";

static const CGFloat kStatusAtMe_RetweetImageHeight = 70.0;

static NSMutableDictionary *sharedImageSizeDictionary;

@interface LYStatusAtMeCell () <TTTAttributedLabelDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *vipIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *fromLabel;

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) LYCollectionView *collectionView;

@property (nonatomic, strong) UIButton *retweetBgView;
@property (nonatomic, strong) UIImageView *retweetImageView;
@property (nonatomic, strong) UILabel *retweetContentLabel;

@property (nonatomic, strong) UIButton *repostButton, *commentButton, *likeButton;

@end

@implementation LYStatusAtMeCell

+ (void)initialize {
    sharedImageSizeDictionary = [NSMutableDictionary dictionary];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.canLoadImage = YES;
        
        _iconView = ({
            UIImageView *iv = [UIImageView new];
            iv.layer.cornerRadius = 17.0;
            iv.layer.masksToBounds = YES;
            [self.contentView addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(34, 34));
                make.left.equalTo(self.contentView).offset(10);
                make.top.equalTo(self.contentView).offset(15);
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
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.iconView.mas_right).offset(15);
                make.top.equalTo(self.contentView).offset(15);
            }];
            label;
        });
        
        _levelView = [UIImageView new];
        [self.contentView addSubview:_levelView];
        [_levelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(5);
            make.centerY.equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        _fromLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel);
                make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            }];
            label;
        });
        
        _contentLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            label.delegate = self;
            label.lineSpacing = 2.0;
            label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            label.font = [UIFont systemFontOfSize:16];
            label.numberOfLines = 0;
            label.linkAttributes = kLinkAttributes;
            label.activeLinkAttributes = kLinkAttributesActive;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(10);
                make.right.equalTo(self.contentView).offset(-10);
                make.top.equalTo(self.iconView.mas_bottom).offset(10);
            }];
            label;
        });
        
        _repostButton = ({
            UIButton *button = [self buttonWithIndex:0];
            [button setImage:[UIImage imageNamed:@"timeline_icon_retweet"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"timeline_icon_retweet_disable"] forState:UIControlStateDisabled];
            button;
        });
        
        _commentButton = ({
            UIButton *button = [self buttonWithIndex:1];
            [button setImage:[UIImage imageNamed:@"timeline_icon_comment"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"timeline_icon_comment_disable"] forState:UIControlStateDisabled];
            button;
        });
        
        _likeButton = ({
            UIButton *button = [self buttonWithIndex:2];
            [button setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"timeline_icon_like_disable"] forState:UIControlStateDisabled];
            button;
        });
        
        UIImageView *vertical_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_vertical_separator"]];
        [self.contentView addSubview:vertical_1];
        [vertical_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.repostButton.mas_right);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(1, 23));
        }];
        
        UIImageView *vertical_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_vertical_separator"]];
        [self.contentView addSubview:vertical_2];
        [vertical_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentButton.mas_right);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(1, 23));
        }];
        
        UIImageView *horizontal = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:horizontal];
        [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.repostButton.mas_top);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(2);
        }];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (_retweetImageView) {
        self.retweetImageView.image = nil;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

- (LYCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[LYCollectionView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20.0, 50.0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[LYStatusImageCCell class] forCellWithReuseIdentifier:kCCellIdentifier_LYStatusImage];
    }
    return _collectionView;
}

- (UIButton *)buttonWithIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setBackgroundImage:[UIImage imageWithColor:LYBackgroundColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kScreen_Width / 3.0 * index);
        make.bottom.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width / 3.0, 34));
    }];
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
        }
        _vipIcon.image = imageName == nil ? nil : [UIImage imageNamed:imageName];
    }
    
    _nameLabel.text = _currentStatus.user.screen_name;
    _nameLabel.textColor = _currentStatus.user.mbrank.integerValue > 0 ? LYMainColor : [UIColor colorWithWhite:34.0/255 alpha:1];
    
    _levelView.hidden = _currentStatus.user.mbrank.integerValue <= 0;
    if (_currentStatus.user.mbrank.integerValue > 0) {
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%@", _currentStatus.user.mbrank.stringValue];
        _levelView.image = [UIImage imageNamed:imageName];
    }
    
    _fromLabel.text = [NSString stringWithFormat:@"%@  %@", [[_currentStatus.created_at systemDate] stringDisplay_HHmm], _currentStatus.source ?: @""];
    
    _contentLabel.text = _currentStatus.text;
    for (NSTextCheckingResult *result in _currentStatus.items) {
        [_contentLabel addLinkToTransitInformation:@{@"value" : result, @"text" : _currentStatus.text} withRange:result.range];
    }
    
    if (_currentStatus.reposts_count && _currentStatus.reposts_count.integerValue > 0) {
        [self.repostButton setTitle:_currentStatus.reposts_count.stringValue forState:UIControlStateNormal];
    } else {
        [self.repostButton setTitle:@"转发" forState:UIControlStateNormal];
    }
    if (_currentStatus.comments_count && _currentStatus.comments_count.integerValue > 0) {
        [self.commentButton setTitle:_currentStatus.comments_count.stringValue forState:UIControlStateNormal];
    } else {
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
    }
    if (_currentStatus.attitudes_count && _currentStatus.attitudes_count.integerValue > 0) {
        [self.likeButton setTitle:_currentStatus.attitudes_count.stringValue forState:UIControlStateNormal];
    } else {
        [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    
    if (_currentStatus.retweeted_status) {
        LYStatus *retweetedStatus = _currentStatus.retweeted_status;
        self.retweetBgView.frame = self.currentStatus.retweetFrame;
        [self.retweetBgView setHidden:NO];
        self.retweetContentLabel.attributedText = [self retweetString];
        if (retweetedStatus.pic_urls.count > 0) {
            if (self.canLoadImage) {
                [self.retweetImageView sd_setImageWithURL:[NSURL URLWithString:retweetedStatus.pic_urls.firstObject[@"thumbnail_pic"]]];
            }
        } else {
            [self.retweetImageView sd_setImageWithURL:[NSURL URLWithString:retweetedStatus.user.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
        }
    } else {
        if (_retweetBgView) {
            [_retweetBgView setHidden:YES];
        }
    }
    
    if (_currentStatus.pic_urls.count > 0) {
        if (self.collectionView.superview != self.contentView) {
            [self.collectionView removeFromSuperview];
            [self.contentView addSubview:self.collectionView];
        }
        self.collectionView.frame = self.currentStatus.picsViewFrame;
        [self.collectionView setHidden:NO];
        [self.collectionView reloadData];
    } else {
        if (_collectionView) {
            [self.collectionView setHidden:YES];
        }
    }
}

- (NSAttributedString *)retweetString {
    
    LYStatus *retweet = self.currentStatus.retweeted_status;
    
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attString_1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"@%@\n", retweet.user.screen_name] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor colorWithWhite:34.0/255 alpha:1]}];
    
    NSAttributedString *attString_2 = [[NSAttributedString alloc] initWithString:retweet.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor grayColor]}];
    
    [mutableAttString appendAttributedString:attString_1];
    [mutableAttString appendAttributedString:attString_2];
    
    return mutableAttString;
}

- (UIButton *)retweetBgView {
    if (!_retweetBgView) {
        _retweetBgView = [[UIButton alloc] init];
        [_retweetBgView addTarget:self action:@selector(showRetweetStatus) forControlEvents:UIControlEventTouchUpInside];
        [_retweetBgView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:247.0/255 alpha:1]] forState:UIControlStateNormal];
        [_retweetBgView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:237.0/255 alpha:1]] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_retweetBgView];
    }
    return _retweetBgView;
}

- (UIImageView *)retweetImageView {
    if (!_retweetImageView) {
        _retweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kStatusAtMe_RetweetImageHeight, kStatusAtMe_RetweetImageHeight)];
        [self.retweetBgView addSubview:_retweetImageView];
    }
    return _retweetImageView;
}

- (UILabel *)retweetContentLabel {
    if (!_retweetContentLabel) {
        _retweetContentLabel = [[UILabel alloc] init];
        _retweetContentLabel.numberOfLines = 3;
        [self.retweetBgView addSubview:_retweetContentLabel];
        [_retweetContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.retweetImageView.mas_right).offset(10);
            make.right.equalTo(self.retweetBgView).offset(-15);
            make.centerY.equalTo(self.retweetBgView);
        }];
    }
    return _retweetContentLabel;
}

#pragma mark - TTTAttributedLabelDelegate
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
    return self.currentStatus.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYStatusImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_LYStatusImage forIndexPath:indexPath];
    cell.canLoadImage = self.canLoadImage;
    cell.url = self.currentStatus.pic_urls[indexPath.row][@"thumbnail_pic"];
    ESWeakSelf
    cell.imageDownloadFinished = ^(UIImage *image, NSString *url) {
        ESStrongSelf
        NSString *lastPathComponent = [url lastPathComponent];
        if (strongSelf.currentStatus.pic_urls.count == 1 && [lastPathComponent isEqualToString:[strongSelf.currentStatus.pic_urls.firstObject[@"thumbnail_pic"] lastPathComponent]]) {
            if (!sharedImageSizeDictionary[lastPathComponent]) {
                sharedImageSizeDictionary[lastPathComponent] = @YES;
                strongSelf.currentStatus.picViewSize = [strongSelf recalculateSize:image.size];
                strongSelf.currentStatus.cellHeight = 0.0;
                [strongSelf.tableView reloadData];
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger idx = 0; idx < self.currentStatus.pic_urls.count; idx ++) {
        MJPhoto *photo = [MJPhoto new];
        NSString *url = [self.currentStatus.pic_urls[idx][@"thumbnail_pic"] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
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
    return self.currentStatus.picViewSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (CGSize)recalculateSize:(CGSize)originalSize {
    CGFloat maxWidth = kScreen_Width * 0.6;
    CGSize reSize = CGSizeZero;
    CGFloat sw = originalSize.width / maxWidth;
    CGFloat sh = originalSize.height / maxWidth;
    
    if (sh / sw > 2.0) {
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

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status {
    CGFloat cellHeight = 49.0;
    
    cellHeight += 10 + [status.text boundingHeightWithFont:[UIFont systemFontOfSize:16] size:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX) lineSpacing:2] + 10.0;
    
    if (status.pic_urls.count <= 0) {
        status.picsViewFrame = CGRectZero;
        status.picViewSize = CGSizeZero;
    } else {
        if (status.pic_urls.count > 1) {
            status.picViewSize = CGSizeMake((kScreen_Width - 30) / 3.0, (kScreen_Width - 30) / 3.0);
            NSInteger line = (status.pic_urls.count + 2) / 3;
            NSInteger row = status.pic_urls.count <= 2 ? status.pic_urls.count : 3;
            if (status.pic_urls.count == 4) {
                row = 2;
            }
            status.picsViewFrame = CGRectMake(10, cellHeight, row * (status.picViewSize.width + 5) - 5, line * (status.picViewSize.height + 5) - 5);
        } else {
            if (CGSizeEqualToSize(status.picViewSize, CGSizeZero)) {
                status.picViewSize = CGSizeMake((kScreen_Width - 30.0) / 3.0, (kScreen_Width - 30.0) / 3.0);
            }
            status.picsViewFrame = CGRectMake(10, cellHeight, status.picViewSize.width, status.picViewSize.height);
        }
        cellHeight += status.picsViewFrame.size.height;
        cellHeight += 10.0;
    }
    
    if (status.retweeted_status) {
        status.retweetFrame = CGRectMake(10, cellHeight, kScreen_Width - 20, 70.0);
        cellHeight += 70.0;
    }

    cellHeight += 34.0;
        
    return cellHeight;
}

@end
