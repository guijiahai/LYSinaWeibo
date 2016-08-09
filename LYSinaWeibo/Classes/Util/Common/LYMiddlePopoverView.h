//
//  LYMiddlePopoverView.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/18.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LYMiddlePopoverViewDataSource, LYMiddlePopoverViewDelegate;

@interface LYMiddlePopoverView : UIView

@property (nonatomic, weak) id <LYMiddlePopoverViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <LYMiddlePopoverViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@property (nonatomic, readonly, nullable) NSIndexPath *indexPathForSelectedRow;
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)show;
- (void)dismiss;

@end

@protocol LYMiddlePopoverViewDataSource <NSObject>

@required

- (NSArray <NSString *> *)middlePopoverView:(LYMiddlePopoverView *)popoverView titlesForSection:(NSInteger)section;

@optional

- (NSInteger)numberOfSectionsInMiddlePopoverView:(LYMiddlePopoverView *)popoverView; // default is 1.

- (nullable NSString *)titleOfBottomButtonInMiddlePopoverView:(LYMiddlePopoverView *)popoverView;
- (nullable NSString *)middlePopoverView:(LYMiddlePopoverView *)popoverView titleForHeaderInSection:(NSInteger)section;

@end

@protocol LYMiddlePopoverViewDelegate <NSObject>

@optional

- (void)middlePopoverView:(LYMiddlePopoverView *)popoverView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)bottomButtonDidSelectInMiddlePopoverView:(LYMiddlePopoverView *)popoverView;
- (void)middlePopoverViewDidDismiss:(LYMiddlePopoverView *)popoverView;

@end

NS_ASSUME_NONNULL_END

