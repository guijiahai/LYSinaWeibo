//
//  LYNetworkTool.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYNetworkTool.h"

static NSString *const LYBaseURLString = @"https://api.weibo.com/";

@implementation LYNetworkTool

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    static LYNetworkTool *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:LYBaseURLString]];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    });
    return instance;
}

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [super GET:URLString parameters:parameters progress:downloadProgress success:^(NSURLSessionDataTask *task_, id _Nullable responseObject_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            success(task_, responseObject_);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task_, NSError *error_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task_, error_);
        }
    }];
}

- (NSURLSessionDataTask *)requestGETWithPath:(NSString *)path parameters:(NSDictionary *)parameters andBlock:(void (^)(id, NSError *))block {
    return [self GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id error = [self handleResponse:responseObject];
        if (block) {
            block(responseObject, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)requestPOSTWithPath:(NSString *)path parameters:(NSDictionary *)parameters andBlock:(void (^)(id, NSError *))block {
    return [self POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id error = [self handleResponse:responseObject];
        if (block) {
            block(responseObject, error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(NSURLSessionDataTask *task))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [super HEAD:URLString parameters:parameters success:^(NSURLSessionDataTask *task_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            success(task_);
        }
    } failure:^(NSURLSessionDataTask *task_, NSError *error_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task_, error_);
        }
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [super POST:URLString parameters:parameters progress:uploadProgress success:^(NSURLSessionDataTask *task_, id responseObject_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            success(task_, responseObject_);
        }
    } failure:^(NSURLSessionDataTask *task_, NSError *error_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task_, error_);
        }
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask *task_, NSError *error_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            success(task_, error_);
        }
    } failure:^(NSURLSessionDataTask *task_, NSError *error_) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (failure) {
            failure(task_, error_);
        }
    }];
}


@end
