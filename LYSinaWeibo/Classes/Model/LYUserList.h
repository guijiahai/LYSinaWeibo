//
//  LYUserList.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUser.h"

typedef NS_ENUM(NSInteger, LYUserListType) {
    LYUserListTypeStatusLikes,
    LYUserListTypeFriends,
    LYUserListTypeFollowers
};

@interface LYUserList : NSObject

/* 当list为nil，表示还未从服务器上获取数据 */
@property (nonatomic, strong) NSMutableArray <LYUser *> *list;

@property (nonatomic, assign) NSInteger page;   //当前的页码，开始为1
@property (nonatomic, strong) NSNumber *originalStatusID;   //要查询的微博ID
@property (nonatomic, strong) NSString *uid;        //要查询的uid
@property (nonatomic, assign) BOOL willLoadMore;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, readonly, getter=isLoadFailed) BOOL loadFailed;

+ (instancetype)userListWithType:(LYUserListType)type;

- (void)configWithData:(NSDictionary *)data;
- (void)loadFailed;

- (NSString *)toSearchPath;
- (NSDictionary *)toSearchParams;

@end
