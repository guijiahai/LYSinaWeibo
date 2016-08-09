//
//  LYComposeImagesCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYPlaceholderTextView.h"

extern NSString *const kCellIdentifier_ComposeImages;

@interface LYComposeImagesCell : UITableViewCell

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, copy) void (^addImageButtonClicked)();
@property (nonatomic, copy) void (^deleteImageButtonClicked)(NSInteger index);
@property (nonatomic, copy) void (^exchangeImageBlock)(NSInteger fromIndex, NSInteger toIndex);

+ (CGFloat)cellHeight;

@end
