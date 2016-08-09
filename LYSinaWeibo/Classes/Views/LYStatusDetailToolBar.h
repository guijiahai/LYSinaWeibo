//
//  LYStatusDetailToolBar.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LYStatusDetailToolBarButtonType) {
    LYStatusDetailToolBarButtonTypeRetweet,
    LYStatusDetailToolBarButtonTypeComment,
    LYStatusDetailToolBarButtonTypeLikeOrUnlike
};

@protocol LYStatusDetailToolBarDelegate;

@interface LYStatusDetailToolBar : UIView

@property (nonatomic, weak) id <LYStatusDetailToolBarDelegate> delegate;

@property (nonatomic, assign) BOOL likeOrUnlike;    //no:normal状态，yes：已点赞

@end

@protocol LYStatusDetailToolBarDelegate <NSObject>

- (void)statusDetailToolBar:(LYStatusDetailToolBar *)toolBar didTouchWithButtonType:(LYStatusDetailToolBarButtonType)buttonType;

@end
