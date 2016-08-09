//
//  LYProfileHeaderCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/23.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYProfileHeaderCell.h"
#import "LYUser.h"

NSString *const kCellIdentifier_ProfileHeader = @"LYProfileHeaderCell";
NSString *const kNibName_ProfileHeaderCell = @"LYProfileHeaderCell";

@interface LYProfileHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@property (nonatomic, weak) UIResponder *curResponder;

@end

@implementation LYProfileHeaderCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap_1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusTap)];
    self.statusLabel.userInteractionEnabled = YES;
    [self.statusLabel addGestureRecognizer:tap_1];
    
    UITapGestureRecognizer *tap_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendsTap)];
    self.friendsLabel.userInteractionEnabled = YES;
    [self.friendsLabel addGestureRecognizer:tap_2];
        
    UITapGestureRecognizer *tap_3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followersTap)];
    self.followersLabel.userInteractionEnabled = YES;
    [self.followersLabel addGestureRecognizer:tap_3];
}

- (void)statusTap {
    if (self.didTapHandler) {
        self.didTapHandler(LYProfileHeaderCellTapTypeStatus);
    }
}

- (void)friendsTap {
    if (self.didTapHandler) {
        self.didTapHandler(LYProfileHeaderCellTapTypeFriends);
    }
}

- (void)followersTap {
    if (self.didTapHandler) {
        self.didTapHandler(LYProfileHeaderCellTapTypeFollowers);
    }
}

- (void)setCurrentUser:(LYUser *)currentUser {
    _currentUser = currentUser;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_currentUser.profile_image_url] placeholderImage:[UIImage imageNamed:LYAvatarDefaultSmallImageName]];
    self.nameLabel.text = _currentUser.screen_name;
    
    self.introLabel.text = [NSString stringWithFormat:@"简介:%@", _currentUser.description_.length > 0 ? _currentUser.description_ : @"暂无介绍"];
    
   
    self.statusLabel.attributedText = [self attributedTextWithTitle:@"微博" count:_currentUser.statuses_count];
    self.friendsLabel.attributedText = [self attributedTextWithTitle:@"关注" count:_currentUser.friends_count];
    self.followersLabel.attributedText = [self attributedTextWithTitle:@"粉丝" count:_currentUser.followers_count];
}

- (NSAttributedString *)attributedTextWithTitle:(NSString *)title count:(NSNumber *)count {
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:count.stringValue attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15]}]];
    [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:[@"\n" stringByAppendingString:title] attributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    return attrText;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.curResponder == self || self.curResponder == self.contentView) {
        self.backgroundColor = highlighted ? LYBackgroundColor : [UIColor whiteColor];
        self.vipView.highlighted = highlighted;
        self.arrowView.highlighted = highlighted;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    self.curResponder = view;
    return view;
}

+ (CGFloat)cellHeight {
    return 135.0;
}

@end
