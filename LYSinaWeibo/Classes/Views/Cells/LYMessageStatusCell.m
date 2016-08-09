//
//  LYMessageStatusCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYMessageStatusCell.h"

NSString *const kCellIdentifier_MessageStatus = @"LYMessageStatusCell";

@interface LYMessageStatusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LYMessageStatusCell

- (void)awakeFromNib {
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setType:(LYMessageStatusType)type {
    _type = type;
    switch (_type) {
        case LYMessageStatusTypeAT:
            self.iconView.image = [UIImage imageNamed:@"messagescenter_at"];
            self.titleLabel.text = @"@我的";
            break;
        case LYMessageStatusTypeComment:
            self.iconView.image = [UIImage imageNamed:@"messagescenter_comments"];
            self.titleLabel.text = @"评论";
            break;
        case LYMessageStatusTypeLike:
            self.iconView.image = [UIImage imageNamed:@"messagescenter_good"];
            self.titleLabel.text = @"赞";
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
}

+ (CGFloat)cellHeight {
    return 68.0;
}

@end
