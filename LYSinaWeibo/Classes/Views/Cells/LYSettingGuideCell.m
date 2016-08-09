//
//  LYSettingGuideCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYSettingGuideCell.h"

NSString *const kCellIdentifier_SettingGuide = @"LYSettingGuideCell";


@implementation LYSettingGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = LYBackgroundColor;
        
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)setType:(LYSettingGuideType)type {
    _type = type;
    NSString *imageName = nil;
    NSString *text = nil;
    switch (_type) {
        case LYSettingGuideTypeAtDot:
            imageName = @"settings_guide_at_dot";
            text = @"@我的";
            break;
        case LYSettingGuideTypeAtNumber:
            imageName = @"settings_guide_at_number";
            text = @"@我的";
            break;
        case LYSettingGuideTypeCommentDot:
            imageName = @"settings_guide_comment_dot";
            text = @"评论";
            break;
        case LYSettingGuideTypeCommentNumber:
            imageName = @"settings_guide_comment_number";
            text = @"评论";
            break;
    }
    UIImage *image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 60, 0, 30)];
    self.imageView.image = image;
    self.textLabel.text = text;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:self.textLabel];
    self.imageView.frame = CGRectMake(12.0, 0, kScreen_Width - 24.0, [[self class] cellHeight]);
    self.textLabel.origin = CGPointMake(80.0, ([[self class] cellHeight] - self.textLabel.height) / 2);
}

+ (CGFloat)cellHeight {
    return 59.0;
}

@end
