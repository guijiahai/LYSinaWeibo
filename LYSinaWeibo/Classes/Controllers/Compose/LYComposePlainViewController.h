//
//  LYComposePlainViewController.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseViewController.h"

typedef NS_ENUM(NSInteger, LYComposePlainStyle) {
    LYComposePlainStyleText,
    LYComposePlainStyleMedia
};

@interface LYComposePlainViewController : LYBaseViewController

+ (instancetype)viewControllerWithStyle:(LYComposePlainStyle)style;

@end
