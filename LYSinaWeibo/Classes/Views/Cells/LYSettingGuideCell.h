//
//  LYSettingGuideCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/20.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_SettingGuide;

typedef NS_ENUM(NSInteger, LYSettingGuideType) {
    LYSettingGuideTypeAtDot,
    LYSettingGuideTypeAtNumber,
    LYSettingGuideTypeCommentDot,
    LYSettingGuideTypeCommentNumber
};

@interface LYSettingGuideCell : UITableViewCell

@property (nonatomic, assign) LYSettingGuideType type;

+ (CGFloat)cellHeight;

@end
