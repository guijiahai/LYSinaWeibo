//
//  LYLogin.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYLogin.h"
#import "LYUser.h"

static NSString *const kLoginUserDictionaryKey = @"kLoginUserDictionaryKey";
static NSString *const kLoginInfoDictionaryKey = @"kLoginInfoDictionaryKey";
//static NSString *const kLogin_access_token_key = @"access_token";
//static NSString *const kLogin_expires_in_key = @"expires_in";
//static NSString *const kLogin_uid_key = @"uid";

@interface LYLogin ()

@property (nonatomic, strong) NSString *access_token;

@property (nonatomic, strong) NSDate *expires_in;

@property (nonatomic, strong) NSString *uid;

@property (nonatomic, strong) LYUser *currentUser;

@end

@implementation LYLogin

+ (instancetype)sharedLogin {
    static dispatch_once_t predicate;
    static id instance;
    dispatch_once(&predicate, ^{
        instance = [[LYLogin alloc] init];
    });
    return instance;
}

- (BOOL)isLogin {
    if (self.uid && self.access_token && self.currentUser) {
        if ([self.expires_in compare:[NSDate date]] == NSOrderedDescending) {
            return YES;
        }
    }
    return NO;
}

- (void)loginWithData:(NSDictionary *)data {
    if (data) {
        self.access_token = data[@"access_token"];
        NSInteger expires = [data[@"expires_in"] integerValue];
        self.expires_in = [NSDate dateWithTimeIntervalSinceNow:expires];
        self.uid = data[@"uid"];
        NSLog(@"uid : %@", self.uid);
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLoginInfoDictionaryKey];
        
    } else {
        [self logout];
    }
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginInfoDictionaryKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUserDictionaryKey];
    self.access_token = nil;
    self.expires_in = nil;
    self.uid = nil;
    self.currentUser = nil;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
}

- (void)loadInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *infoDict = [defaults objectForKey:kLoginInfoDictionaryKey];
    if (infoDict) {
        [self loginWithData:infoDict];
    }
    NSDictionary *userDict = [defaults objectForKey:kLoginUserDictionaryKey];
    if (userDict) {
        self.currentUser = [LYUser mj_objectWithKeyValues:userDict];
    }
}

- (void)loadUserInfoWithBlock:(void (^)(BOOL))block {
    
    ESWeakSelf
    [[LYNetworkTool sharedTool] requestGETWithPath:[LYUser toInfoPath] parameters:@{@"access_token" : self.access_token, @"uid" : self.uid} andBlock:^(id data, NSError *error) {
        ESStrongSelf
        
        if (!error) {
            strongSelf.currentUser = [LYUser mj_objectWithKeyValues:data context:nil];
            //直接保存responseObject会崩溃
            NSDictionary *result = [strongSelf.currentUser mj_JSONObject];
            [[NSUserDefaults standardUserDefaults] setObject:result forKey:kLoginUserDictionaryKey];
        }
        if (block) {
            block(error == nil);
        }
    }];
}

@end
