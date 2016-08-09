//
//  LYStatusDetailLoadCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusDetailLoadCell.h"

NSString *const kCellIdentifier_LYStatusDetailLoad = @"LYStatusDetailLoadCell";

@interface LYStatusDetailLoadCell ()

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIButton *reloadButton;


@end

@implementation LYStatusDetailLoadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:252.0/255 alpha:1];

    }
    return self;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.numberOfLines = 0;
        _remindLabel.textColor = [UIColor colorWithWhite:153.0/255 alpha:1];
        [self.contentView addSubview:_remindLabel];
        [_remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-25);
            make.left.mas_greaterThanOrEqualTo(self.contentView).offset(15);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _remindLabel;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = YES;
        [self.contentView addSubview:_indicator];
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(30);
        }];
    }
    return _indicator;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor colorWithWhite:106.0/255 alpha:1] forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _reloadButton.layer.borderColor = [UIColor colorWithWhite:217.0/255 alpha:1].CGColor;
        _reloadButton.layer.borderWidth = 1;
        _reloadButton.layer.cornerRadius = 4.0;
        [_reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:252.0/255 alpha:1]] forState:UIControlStateNormal];
        [_reloadButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:237.0/255 alpha:1]] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_reloadButton];
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(190, 44));
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_centerY);
        }];
    }
    return _reloadButton;
}

- (void)setLoadState:(LYStatusDetailLoadState)loadState {
    _loadState = loadState;
    switch (_loadState) {
        
        case LYStatusDetailLoadStateIng:
        {
            if (_remindLabel) {
                [self.remindLabel setHidden:YES];
            }
            if (_reloadButton) {
                [self.reloadButton setHidden:YES];
            }
            [self.indicator startAnimating];
        }
            break;
        case LYStatusDetailLoadStateFailed:
        {
            self.remindLabel.text = @"网络出错了，请点击按钮重新加载";
            [self.remindLabel setHidden:NO];
            [self.reloadButton setHidden:NO];
            if (_indicator && _indicator.isAnimating) {
                [self.indicator stopAnimating];
            }
        }
            break;
        case LYStatusDetailLoadStateNoData:
        {
            if (_indicator) {
                [self.indicator stopAnimating];
            }
            if (_reloadButton) {
                [self.reloadButton setHidden:YES];
            }
            [self.remindLabel setHidden:NO];
            self.remindLabel.text = self.noDataText ?: @"还没有数据";
        }
            break;
        case LYStatusDetailLoadStateNothing:
        default:
        {
            if (_indicator) {
                [_indicator stopAnimating];
            }
            if (_remindLabel) {
                [self.remindLabel setHidden:YES];
            }
            if (_reloadButton) {
                [self.reloadButton setHidden:YES];
            }
        }
            break;
    }
}

- (void)setNoDataText:(NSString *)noDataText {
    _noDataText = noDataText;
    self.loadState = self.loadState;
}

- (void)reload {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

+ (CGFloat)cellHeight {
    return 200.0;
}

@end
