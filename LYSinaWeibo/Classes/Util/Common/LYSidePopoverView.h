//
//  LYSidePopoverView.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/18.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LYSidePopoverViewStyle) {
    LYSidePopoverViewStyleLeft,
    LYSidePopoverViewStyleRight
};

@protocol LYSidePopoverViewDelegate;

@interface LYSidePopoverView : UIView

@property (nonatomic, weak, nullable) id <LYSidePopoverViewDelegate> delegate;

- (instancetype)initWithStyle:(LYSidePopoverViewStyle)style titles:(NSArray <NSString *> *)titles images:(NSArray <UIImage *> *)images;

@property (nonatomic, copy, nullable) void (^didSelectRowAtIndex)(NSInteger index);

- (void)show;
- (void)dismiss;

@end

@protocol LYSidePopoverViewDelegate <NSObject>

@optional

- (void)sidePopoverView:(LYSidePopoverView *)popoverView didSelectRowAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END