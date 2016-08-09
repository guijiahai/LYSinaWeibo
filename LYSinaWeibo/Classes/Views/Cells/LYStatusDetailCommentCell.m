//
//  LYStatusDetailCommentCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailCommentCell.h"
#import "TTTAttributedLabel.h"
#import "LYWebViewController.h"
#import "LYComment.h"

NSString *const kCellIdentifier_LYStatusDetailComment = @"LYStatusDetailCommentCell";

@interface LYStatusDetailCommentCell () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *separator;

@end

@implementation LYStatusDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = ({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            iv.layer.cornerRadius = 20.0;
            iv.layer.masksToBounds = YES;
            [self.contentView addSubview:iv];
            iv;
        });
        
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconView.mas_right).offset(10);
                make.top.equalTo(self.contentView).offset(10);
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
        
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithHexString:@"0xb4b4b4"];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconView.mas_right).offset(10);
                make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            }];
            label;
        });
        
        _contentLabel = ({
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
            label.textColor = [UIColor colorWithWhite:102.0/255 alpha:1];
            label.lineSpacing = 2.0;
            label.linkAttributes = kLinkAttributes;
            label.activeLinkAttributes = kLinkAttributesActive;
            label.delegate = self;
            label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            label.font = [UIFont systemFontOfSize:14];
            label.numberOfLines = 0;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_iconView.mas_right).offset(10);
                make.top.equalTo(_iconView.mas_bottom).offset(5);
                make.right.equalTo(self.contentView).offset(-20);
            }];
            label;
        });
        
        _separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView.mas_right).offset(10);
            make.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = [UIColor colorWithWhite:(highlighted ? 230.0 : 250.0) / 255.0 alpha:1];
}

- (void)setCurrentComment:(LYComment *)currentComment {
    _currentComment = currentComment;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_currentComment.user.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    _nameLabel.text = _currentComment.user.screen_name;
    _nameLabel.textColor = _currentComment.user.mbrank.integerValue > 0 ? LYMainColor : [UIColor colorWithWhite:34.0/255 alpha:1];
    
    _levelView.hidden = _currentComment.user.mbrank.integerValue <= 0;
    if (_currentComment.user.mbrank.integerValue > 0) {
        NSString *imageName = [NSString stringWithFormat:@"common_icon_membership_level%@", _currentComment.user.mbrank.stringValue];
        _levelView.image = [UIImage imageNamed:imageName];
    }
    
    _timeLabel.text = [[_currentComment.created_at systemDate] stringDisplay_HHmm];
    
    _contentLabel.text = _currentComment.text;
    for (NSTextCheckingResult *result in _currentComment.items) {
        [_contentLabel addLinkToTransitInformation:@{@"text" : _currentComment.text, @"value" : result} withRange:result.range];
    }
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

+ (CGFloat)cellHeightWithComment:(LYComment *)comment {
    CGFloat cellHeight = 0.0;
    cellHeight += 50.0;         //header
    cellHeight += 5.0;          //间距
    cellHeight += [comment.text boundingHeightWithFont:[UIFont systemFontOfSize:14] size:CGSizeMake(kScreen_Width - 60 - 20, CGFLOAT_MAX) lineSpacing:2.0];
    cellHeight += 10.0;
    return cellHeight;
}

@end
