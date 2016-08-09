//
//  LYPlaceholderTextView.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPlaceholderTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) CGFloat placeholderLineSpacing;

@end
