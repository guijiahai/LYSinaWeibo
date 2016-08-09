//
//  LYComposeTextCell.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYPlaceholderTextView.h"

extern NSString *const kCellIdentifier_ComposeText;

@interface LYComposeTextCell : UITableViewCell

@property (nonatomic, strong, readonly) LYPlaceholderTextView *textView;

@property (nonatomic, copy) void (^textValueDidChangeBlock)(NSString *textValue);


+ (CGFloat)cellHeight;

@end
