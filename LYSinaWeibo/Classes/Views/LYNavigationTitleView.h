//
//  LYNavigationTitleView.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/18.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYNavigationTitleViewDelegate;

@interface LYNavigationTitleView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, weak) id<LYNavigationTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end


@protocol LYNavigationTitleViewDelegate <NSObject>

- (void)navigationTitleViewDidSelectItem:(LYNavigationTitleView *)titleView;

@end