//
//  LYStatusDetailLoadCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCellIdentifier_LYStatusDetailLoad;

typedef NS_ENUM(NSInteger, LYStatusDetailLoadState) {
    LYStatusDetailLoadStateNothing,
    LYStatusDetailLoadStateIng,
    LYStatusDetailLoadStateFailed,
    LYStatusDetailLoadStateNoData
};

@interface LYStatusDetailLoadCell : UITableViewCell

/* 'LYStatusDetailLoadStateNothing' by default. */
@property (nonatomic, assign) LYStatusDetailLoadState loadState;

/* 没有数据时的提示信息 */
@property (nonatomic, strong) NSString *noDataText;

/* LYStatusDetailLoadStateFailed */
@property (nonatomic, copy) void (^reloadBlock)();

+ (CGFloat)cellHeight;

@end
