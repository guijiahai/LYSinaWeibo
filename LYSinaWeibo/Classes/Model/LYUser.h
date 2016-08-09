//
//  LYUser.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYUser : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *screen_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *province;
@property (nonatomic, strong) NSNumber *city;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *description_;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *profile_image_url;
@property (nonatomic, strong) NSString *profile_url;
@property (nonatomic, strong) NSString *avatar_large;
@property (nonatomic, strong) NSString *cover_image;
@property (nonatomic, strong) NSString *cover_image_phone;
@property (nonatomic, strong) NSString *ability_tags;
@property (nonatomic, strong) NSNumber *urank;
@property (nonatomic, strong) NSNumber *mbrank;  //猜测是会员等级
@property (nonatomic, strong) NSString *domain;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSNumber *followers_count;
@property (nonatomic, strong) NSNumber *friends_count;
@property (nonatomic, strong) NSNumber *statuses_count;
@property (nonatomic, strong) NSNumber *favourites_count;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, assign) BOOL following;
@property (nonatomic, assign) BOOL allow_all_act_msg;
@property (nonatomic, assign) BOOL geo_enabled;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) BOOL allow_all_comment;
@property (nonatomic, strong) NSString *avatar_hd;
@property (nonatomic, strong) NSString *verified_reason;
@property (nonatomic, strong) NSNumber *verified_type;  // -1:没有认证，0：认证用户， 2，3，5：企业认证，220:达人
@property (nonatomic, strong) NSString *verified_contact_mobile;
@property (nonatomic, assign) BOOL follow_me;
@property (nonatomic, strong) NSNumber *online_status;
@property (nonatomic, strong) NSNumber *bi_followers_count;
@property (nonatomic, strong) NSString *lang;
@property (nonatomic, strong) NSArray *pic_urls;

+ (NSString *)toInfoPath;
- (NSDictionary *)toInfoParams;

@end
