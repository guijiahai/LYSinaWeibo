//
//  LYStatusListCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusListCell.h"
#import "LYStatus.h"
#import "LYWebViewController.h"
#import "LYCollectionView.h"
#import "LYStatusImageCCell.h"
#import "MJPhotoBrowser.h"
#import "TTTAttributedLabel.h"

NSString *const kCellIdentifier_LYStatusList = @"LYStatusListCell";

static CGFloat LYStatusListCell_LeftOffset = 10.0;
static CGFloat LYStatusListCell_TopOffset = 15.0;

/*
 当只有一张图片时，imageView的size需要根据image的size来计算，但是一开始是不知道image的size，所以这里先下载image。等image下载完成后，如果是single image， 就根据image的size计算imageView的size
 */
static NSMutableDictionary *sharedImageSizeDictionary;

@interface LYStatusListCell () <TTTAttributedLabelDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *vipIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *fromLabel;

@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) LYCollectionView *collectionView;

@property (nonatomic, strong) UIButton *retweetBgView;
@property (nonatomic, strong) TTTAttributedLabel *retweetContentLabel;
//@property (nonatomic, strong) LYCollectionView *retweetCollectionView;

@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *attitudeButton;

@end

@implementation LYStatusListCell

+ (void)initialize {
    sharedImageSizeDictionary = [NSMutableDictionary dictionary];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.canLoadImage = YES;
        
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
                make.left.equalTo(self.contentView).offset(LYStatusListCell_LeftOffset);
                make.right.equalTo(self.contentView).offset(-LYStatusListCell_LeftOffset);
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
        
        _attitudeButton = ({
            UIButton *button = [self buttonWithIndex:2];
            [button setImage:[UIImage imageNamed:@"timeline_icon_unlike"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"timeline_icon_like"] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"timeline_icon_like_disable"] forState:UIControlStateDisabled];
            button;
        });
        
        UIImageView *verticalLine_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_vertical_separator"]];
        [self.contentView addSubview:verticalLine_1];
        [verticalLine_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.repostButton.mas_right);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(1, 23));
        }];
        
        UIImageView *verticalLine_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_vertical_separator"]];
        [self.contentView addSubview:verticalLine_2];
        [verticalLine_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.commentButton.mas_right);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(1, 23));
        }];
        
        UIImageView *horizontalLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:horizontalLine];
        [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.repostButton.mas_top);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(2);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
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


//button
- (UIButton *)buttonWithIndex:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
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
    
    _contentLabel.text = _currentStatus.text;
    for (NSTextCheckingResult *check in self.currentStatus.items) {
        [_contentLabel addLinkToTransitInformation:@{@"value" : check, @"text" : _currentStatus.text} withRange:check.range];
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
        [self.attitudeButton setTitle:_currentStatus.attitudes_count.stringValue forState:UIControlStateNormal];
    } else {
        [self.attitudeButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    
    if (_currentStatus.retweeted_status) {
        LYStatus *retweetedStatus = _currentStatus.retweeted_status;
        self.retweetBgView.frame = self.currentStatus.retweetFrame;
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
        self.collectionView.frame = self.currentStatus.picsViewFrame;
        [self.collectionView setHidden:NO];
        [self.collectionView reloadData];
    } else if (_currentStatus.retweeted_status.pic_urls.count > 0) {
        if (self.collectionView.superview != self.retweetBgView) {
            [self.collectionView removeFromSuperview];
            [self.retweetBgView addSubview:self.collectionView];
        }
        self.collectionView.frame = self.currentStatus.retweeted_status.picsViewFrame;
        [self.collectionView setHidden:NO];
        [self.collectionView reloadData];
    } else {
        if (_collectionView) {
            [self.collectionView setHidden:YES];
        }
    }
}

- (UIView *)retweetBgView {
    if (!_retweetBgView) {
        _retweetBgView = [[UIButton alloc] init];
        [_retweetBgView addTarget:self action:@selector(showRetweetStatus) forControlEvents:UIControlEventTouchUpInside];
        [_retweetBgView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:247.0/255 alpha:1]] forState:UIControlStateNormal];
        [_retweetBgView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:237.0/255 alpha:1]] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_retweetBgView];
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
            [_retweetBgView addSubview:label];
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
    cell.canLoadImage = self.canLoadImage;
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
        LYStatus *status = strongSelf.currentStatus.retweeted_status ?: strongSelf.currentStatus;
        
        if (status.pic_urls.count == 1 && [lastPathComponent isEqualToString:[status.pic_urls.firstObject[@"thumbnail_pic"] lastPathComponent]]) {
            //使用sharedImageSizeDictionary，防止死循环
            if (!sharedImageSizeDictionary[lastPathComponent]) {
                sharedImageSizeDictionary[lastPathComponent] = @YES;
                status.picViewSize = [strongSelf recalculateSize:image.size];
                strongSelf.currentStatus.cellHeight = 0.0;  //重新计算cellHeight
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
    return status.picViewSize;
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

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status retweeted:(BOOL)retweeted {
    CGFloat cellHeight = 0.0;
    if (!retweeted) {
        cellHeight = 49.0;
    }
    NSString *contentText = status.text ?: @"";
    if (retweeted) {
        contentText = [NSString stringWithFormat:@"@%@ :%@", status.user.screen_name, contentText];
    }
    
    cellHeight += 10 + [contentText boundingHeightWithFont:[UIFont systemFontOfSize:(retweeted ? 14 : 16)] size:CGSizeMake(kScreen_Width - 2 * 10, CGFLOAT_MAX) lineSpacing:2.0] + 10.0;
    
    //计算图片的size，以及图片所在的collectionView的frame
    if (status.pic_urls.count <= 0) {
        status.picsViewFrame = CGRectZero;
        status.picViewSize = CGSizeZero;
    } else {
        if (status.pic_urls.count > 1) {
            status.picViewSize = CGSizeMake((kScreen_Width - 30) / 3, (kScreen_Width - 30) / 3);
            NSInteger line = ((status.pic_urls.count + 2) / 3);
            NSInteger row = status.pic_urls.count <= 2 ? status.pic_urls.count : 3;
            if (status.pic_urls.count == 4) {
                row = 2;
            }
            status.picsViewFrame = CGRectMake(10, cellHeight, row * (status.picViewSize.width + 5) - 5, line * (status.picViewSize.height + 5) - 5);
        } else {
            if (CGSizeEqualToSize(status.picViewSize, CGSizeZero)) {
                status.picViewSize = CGSizeMake((kScreen_Width - 30) / 3, (kScreen_Width - 30) / 3);
            }
            status.picsViewFrame = CGRectMake(10, cellHeight, status.picViewSize.width, status.picViewSize.height);
        }
        cellHeight += status.picsViewFrame.size.height;
        cellHeight += 10.0;
    }
    
    //计算retweetStatus
    if (status.retweeted_status) {
        status.retweetFrame = CGRectMake(0, cellHeight, kScreen_Width, [self cellHeightWithStatus:status.retweeted_status retweeted:YES]);
        cellHeight += status.retweetFrame.size.height;
    }
    //底部buttons
    if (!retweeted) {
        cellHeight += 34.0;
    }
    
    return cellHeight;
}

+ (CGFloat)cellHeightWithStatus:(LYStatus *)status {
    return [self cellHeightWithStatus:status retweeted:NO];
}

@end
