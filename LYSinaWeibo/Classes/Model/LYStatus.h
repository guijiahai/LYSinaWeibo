//
//  LYStatus.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYGeo.h"
#import "LYUser.h"

@interface LYStatus : NSObject

@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *mid;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) BOOL favorited;  //是否已被收藏
@property (nonatomic, assign) BOOL truncated;  //是否被截断 true or false
@property (nonatomic, strong) NSString *thumbnail_pic;
@property (nonatomic, strong) NSString *bmiddle_pic;
@property (nonatomic, strong) NSString *original_pic;
@property (nonatomic, strong) LYGeo *geo;
@property (nonatomic, strong) LYUser *user;
@property (nonatomic, strong) LYStatus *retweeted_status;
@property (nonatomic, strong) NSNumber *reposts_count;
@property (nonatomic, strong) NSNumber *comments_count;
@property (nonatomic, strong) NSNumber *attitudes_count;
@property (nonatomic, strong) id visible;
@property (nonatomic, strong) id pic_ids;
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) NSArray *pic_urls;

/* 解析text中的"@" 和 “#” */
@property (nonatomic, strong, readonly) NSArray <NSTextCheckingResult *> *items;

/* retweeted_status的高度只包括文字内容和图片 */
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGSize picViewSize;
@property (nonatomic, assign) CGRect picsViewFrame;
/* retweeted_status在cell中的frame */
@property (nonatomic, assign) CGRect retweetFrame;

@property (nonatomic, assign) BOOL retweeted;

@end
