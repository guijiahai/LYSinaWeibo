//
//  NSObject+Common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/27.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

// error
+ (NSString *)tipFromError:(NSError *)error;
- (NSError *)handleResponse:(id)response;
- (NSError *)handleResponse:(id)response autoShowError:(BOOL)autoShowError;

// network
+ (BOOL)saveResponseObject:(NSDictionary *)responseObject toPath:(NSString *)path;
+ (id)loadResponseObjectWithPath:(NSString *)path;
+ (BOOL)deleteResponseCacheWithPath:(NSString *)path;
+ (BOOL)deleteResponseCache;

@end
