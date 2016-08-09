//
//  LYFollowUserListViewController.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/30.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYBaseViewController.h"

typedef NS_ENUM(NSInteger, LYFollowUserListType) {
    LYFollowUserListTypeFriends,
    LYFollowUserListTypeFollowers
};

@interface LYFollowUserListViewController : LYBaseViewController

+ (instancetype)viewControllerWithListType:(LYFollowUserListType)listType uid:(NSString *)uid;  //如果是“我”，则不用传uid

@end
