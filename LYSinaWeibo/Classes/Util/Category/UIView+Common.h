//
//  UIView+Common.h
//  百思不得姐
//
//  Created by GuiJiahai on 16/5/19.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EaseBlankPageType) {
    EaseBlankPageTypeDefault,
    EaseBlankPageTypeStatusAtMe,
    EaseBlankPageTypeCommentAtMe,
    EaseBlankPageTypeProfile,
};

@interface UIView (Common)

- (UIViewController *)viewController;

- (BOOL)isShowingInKeyWindow;

@end

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

@property (nonatomic, readonly) CGFloat maxXOfFrame;
@property (nonatomic, readonly) CGFloat maxYOfFrame;

@end


@interface UITableViewCell (Common)

@property (nonatomic, readonly) UITableView *tableView;

@end

@interface UIView (EaseBlankPage)

- (void)configWithType:(EaseBlankPageType)type blank:(BOOL)blank error:(BOOL)error reloadBlock:(void (^)())block;

@end
