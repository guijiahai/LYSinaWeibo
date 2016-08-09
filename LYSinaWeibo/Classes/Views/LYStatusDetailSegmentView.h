//
//  LYStatusDetailSegmentView.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LYStatusDetailSegmentButtonType) {
    LYStatusDetailSegmentButtonTypeRetweet,
    LYStatusDetailSegmentButtonTypeComment,
    LYStatusDetailSegmentButtonTypeLike
};

@protocol LYStatusDetailSegmentViewDelegate;

@interface LYStatusDetailSegmentView : UIView

@property (nonatomic, weak) id <LYStatusDetailSegmentViewDelegate> delegate;

@property (nonatomic, assign) NSUInteger retweetCount;
@property (nonatomic, assign) NSUInteger commentCount;
@property (nonatomic, assign) NSUInteger likeCount;

@property (nonatomic, assign) LYStatusDetailSegmentButtonType selectedButtonType;

- (instancetype)init NS_UNAVAILABLE;

- (void)setRetweetCount:(NSUInteger)retweetCount commentCount:(NSUInteger)commentCount likeCount:(NSUInteger)likeCount;

@end

@protocol LYStatusDetailSegmentViewDelegate <NSObject>

- (void)statusDetailSegmentView:(LYStatusDetailSegmentView *)segmentView didTouchWithButtonType:(LYStatusDetailSegmentButtonType)buttonType;

@end