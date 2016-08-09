//
//  NSObject+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/27.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#define kPath_ResponseCache @"ResponseCache"

#import "NSObject+Common.h"

@implementation NSObject (Common)

+ (NSString *)tipFromError:(NSError *)error {
    if (error && error.userInfo) {
        if (error.userInfo[@"errmsg"]) {
            return error.userInfo[@"errmsg"];
        } else {
            return error.userInfo[NSLocalizedDescriptionKey];
        }
    }
    return nil;
}

- (NSError *)handleResponse:(id)response {
    return [self handleResponse:response autoShowError:YES];
}

- (NSError *)handleResponse:(id)response autoShowError:(BOOL)autoShowError {
    NSInteger errNo = [response[@"errno"] integerValue];
    NSError *error = nil;
    if (errNo != 0) {
        error = [NSError errorWithDomain:NSURLErrorKey code:errNo userInfo:response];
        if (autoShowError) {
            [SVProgressHUD showErrorWithStatus:[NSObject tipFromError:error]];
        }
    }
    return error;
}


+ (BOOL)saveResponseObject:(NSDictionary *)responseObject toPath:(NSString *)path {
    NSString *uid = [LYLogin sharedLogin].uid;
    if (![LYLogin sharedLogin].isLogin) {
        return NO;
    } else {
        path = [NSString stringWithFormat:@"%@_%@", uid, path];
    }
    if ([self createDirInCache:kPath_ResponseCache]) {
        NSString *absolutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [path md5Str]];
        return [responseObject writeToFile:absolutePath atomically:YES];
    } else {
        return NO;
    }
}

+ (id)loadResponseObjectWithPath:(NSString *)path {
    NSString *uid = [LYLogin sharedLogin].uid;
    if (![LYLogin sharedLogin].isLogin) {
        return nil;
    } else {
        path = [NSString stringWithFormat:@"%@_%@", uid, path];
    }
    NSString *absolutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [path md5Str]];
    return [NSMutableDictionary dictionaryWithContentsOfFile:absolutePath];
}

+ (BOOL)deleteResponseCacheWithPath:(NSString *)path {
    NSString *uid = [LYLogin sharedLogin].uid;
    if (![LYLogin sharedLogin].isLogin) {
        return NO;
    } else {
        path = [NSString stringWithFormat:@"%@_%@", uid, path];
    }
    NSString *absolutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ResponseCache], [path md5Str]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:absolutePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:absolutePath error:nil];
    } else {
        return NO;
    }
}

+ (BOOL)deleteResponseCache {
    return [self deleteResponseCacheWithPath:kPath_ResponseCache];
}

+ (NSString *)pathInCacheDirectory:(NSString *)fileName {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [cachePaths.firstObject stringByAppendingPathComponent:fileName];
}

+ (BOOL)createDirInCache:(NSString *)dirName {
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL existed = [fm fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir && existed)) {
        isCreated = [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

@end
