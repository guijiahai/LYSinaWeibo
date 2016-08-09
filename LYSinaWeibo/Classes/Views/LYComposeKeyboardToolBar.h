//
//  LYComposeKeyboardToolBar.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/3.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYComposeKeyboardToolBarDelegate;

@interface LYComposeKeyboardToolBar : UIView

@property (nonatomic, weak) id<LYComposeKeyboardToolBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (void)showInWindow;
- (void)dismiss;

@end

@protocol LYComposeKeyboardToolBarDelegate <NSObject>

@optional

- (void)composeKeyboardToolBarDidClickPictureButton:(LYComposeKeyboardToolBar *)toolBar;
- (void)composeKeyboardToolBarDidClickAtButton:(LYComposeKeyboardToolBar *)toolBar;
- (void)composeKeyboardToolBarDidClickTopicButton:(LYComposeKeyboardToolBar *)toolBar;

@end
