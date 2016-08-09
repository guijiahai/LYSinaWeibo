//
//  LYShareSheet.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LYShareSheetStyle) {
    LYShareSheetStyleStatusDetail,
    LYShareSheetStyleWebView,
    LYShareSheetStyleUserInfo
};

@interface LYShareSheet : UIView

- (instancetype)initWithStyle:(LYShareSheetStyle)style;

- (void)show;

- (void)dismissAnimated:(BOOL)animated;

@end
