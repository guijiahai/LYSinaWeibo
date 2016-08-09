//
//  LYUserList.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/15.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYUserList.h"

@interface LYUserList ()

@property (nonatomic, assign) LYUserListType listType;

@end

@implementation LYUserList

+ (instancetype)userListWithType:(LYUserListType)type {
    LYUserList *list = [[LYUserList alloc] init];
    list.listType = type;
    return list;
}

- (instancetype)init {
    if (self = [super init]) {
        _willLoadMore = _loading = _loadFailed = NO;
        _page = 1;
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    _loadFailed = NO;
    if (_willLoadMore) {
        _page ++;
    } else {
        _page = 1;
        [self.list removeAllObjects];
    }
    if ([data[@"users"] count] > 0) {
        [self.list addObjectsFromArray:[LYUser mj_objectArrayWithKeyValuesArray:data[@"users"]]];
    }
}

- (void)loadFailed {
    _loadFailed = YES;
    if (!_list) {
        _list = [NSMutableArray array];
    }
}

- (NSString *)toSearchPath {
    switch (self.listType) {
        case LYUserListTypeStatusLikes:
            return @"http://api.weibo.cn/2/like/show?networktype=wifi&uicode=10000002&moduleID=700&featurecode=10000001&c=android&i=f1c6047&s=f8df39ee&ua=Meizu-m1%20metal__weibo__6.7.0__android__android5.1&wm=9848_0009&aid=01Al9NpMxB5LgX3P7mqsZIav6hfLqofRD6Qp-UUEd-DSkEIPQ.&v_f=2&v_p=31&from=1067095010&lang=zh_CN&skin=default&type=0&count=50&oldwm=9848_0009&sflag=1&luicode=10000001&filter_by_author=0&filter_by_source=0";
        case LYUserListTypeFriends:
            return @"/2/friendships/friends.json";
        case LYUserListTypeFollowers:
            return @"/2/friendships/followers.json";
    }
    return nil;
}

- (NSDictionary *)toSearchParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[LYLogin sharedLogin].access_token forKey:@"access_token"];
    [params setValue:@(_willLoadMore ? _page + 1 : 1) forKey:@"page"];
    switch (self.listType) {
        case LYUserListTypeStatusLikes:
        {
            [params setValue:LY_Gsid forKey:@"gsid"];
            [params setValue:self.originalStatusID forKey:@"id"];
        }
            break;
        case LYUserListTypeFriends:
        case LYUserListTypeFollowers:
        {
            [params setValue:self.uid forKey:@"uid"];
        }
            break;
    }
    return params;
}

@end
