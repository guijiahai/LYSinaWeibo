//
//  LYRemind.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYRemind : NSObject

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *follower;
@property (nonatomic, strong) NSNumber *cmt;
@property (nonatomic, strong) NSNumber *dm;
@property (nonatomic, strong) NSNumber *mention_status;
@property (nonatomic, strong) NSNumber *mention_cmt;
@property (nonatomic, strong) NSNumber *group;
@property (nonatomic, strong) NSNumber *private_group;
@property (nonatomic, strong) NSNumber *notice;
@property (nonatomic, strong) NSNumber *invite;
@property (nonatomic, strong) NSNumber *badge;
@property (nonatomic, strong) NSNumber *photo;
@property (nonatomic, strong) NSNumber *msgbox;

@end
