//
//  LYActionSheet.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/12.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LYActionSheetDelegate;

@interface LYActionSheet : UIView

- (instancetype)initWithTitle:(nullable NSString *)title delegate:(nullable id<LYActionSheetDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, weak, nullable) id<LYActionSheetDelegate> delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, readonly) NSInteger numberOfButtons;
@property (nonatomic, readonly) NSInteger cancelButtonIndex;

- (NSInteger)addButtonWithTitle:(NSString *)title;
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)index;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end

@protocol LYActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(LYActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
//- (void)actionSheetCancel:(LYActionSheet *)actionSheet;
//- (void)willPresentActionSheet:(LYActionSheet *)actionSheet;
//- (void)didPresentActionSheet:(LYActionSheet *)actionSheet;
//- (void)actionSheet:(LYActionSheet *)actionSheet willDIsmissWithButtonIndex:(NSInteger)buttonIndex;
//- (void)actionSheet:(LYActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END