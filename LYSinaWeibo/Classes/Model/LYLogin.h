//
//  LYLogin.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYUser;

@interface LYLogin : NSObject

/**
 用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一映射关系，来识别登录状态，不能使用本返回值里的uid字段来做登录识别
 */
@property (nonatomic, strong, readonly) NSString *access_token;

/**
 access_token的生命周期，原本是int类型，单位秒,这里在获取到expires_in时，转化成NSDate类型
 */
@property (nonatomic, strong, readonly) NSDate *expires_in;

/**
 授权用户的uid
 */
@property (nonatomic, strong, readonly) NSString *uid;

/**
 当前用户信息
 */
@property (nonatomic, strong, readonly) LYUser *currentUser;

+ (instancetype)sharedLogin;

- (BOOL)isLogin;

- (void)loginWithData:(NSDictionary *)data;
- (void)logout;
- (void)loadInfo;

- (void)loadUserInfoWithBlock:(void (^)(BOOL finished))block;

@end
