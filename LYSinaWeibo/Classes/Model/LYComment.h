//
//  LYComment.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYUser, LYStatus;

@interface LYComment : NSObject

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSNumber *source_type;
@property (nonatomic, strong) NSNumber *floor_number;
@property (nonatomic, strong) NSNumber *source_allowclick;
@property (nonatomic, strong) LYUser *user;
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) LYStatus *status;
@property (nonatomic, strong) LYComment *reply_comment;

/* 解析text中的"@" 和 “#” */
@property (nonatomic, strong, readonly) NSArray <NSTextCheckingResult *> *items;

@property (nonatomic, assign) CGFloat cellHeight;

@end
