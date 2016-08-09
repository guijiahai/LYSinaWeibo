//
//  LYNetworkTool.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface LYNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedTool;

- (NSURLSessionDataTask *)requestGETWithPath:(NSString *)path parameters:(NSDictionary *)parameters andBlock:(void (^)(id data, NSError *error))block;

- (NSURLSessionDataTask *)requestPOSTWithPath:(NSString *)path parameters:(NSDictionary *)parameters andBlock:(void (^)(id data, NSError *error))block;

@end
