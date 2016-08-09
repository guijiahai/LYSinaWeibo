//
//  LYCommentList.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYCommentList.h"

@interface LYCommentList ()

@property (nonatomic, assign, readwrite) LYCommentListType type;

@end

@implementation LYCommentList

+ (instancetype)commentListWithType:(LYCommentListType)type {
    LYCommentList *list = [[LYCommentList alloc] init];
    list.type = type;
    return list;
}

- (instancetype)init {
    if (self = [super init]) {
        _willLoadMore = NO;
        _loading = NO;
        _page = 1;
        _canLoadMore = YES;
        
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
    if ([data[@"comments"] count] > 0) {
        NSArray *comments = [LYComment mj_objectArrayWithKeyValuesArray:data[@"comments"]];
        [self.list addObjectsFromArray:comments];
        _canLoadMore = YES;
    } else {
        _canLoadMore = NO;
    }
}

- (NSString *)toSearchPath {
    switch (self.type) {
        case LYCommentListTypeStatus:
            return @"/2/comments/show.json";
        case LYCommentListTypeByMe:
            return @"/2/comments/by_me.json";
        case LYCommentListTypeToMe:
            return @"/2/comments/to_me.json";
        case LYCommentListTypeTimeline:
            return @"/2/comments/timeline.json";
        case LYCommentListTypeShowBatch:
            return @"/2/comments/show_batch.json";
        case LYCommentListTypeAtMe_All:
        case LYCommentListTypeAtMe_Friends:
            return @"/2/comments/mentions.json";
    }
    return nil;
}

- (void)loadFailed {
    _loadFailed = YES;
    if (!_list) {
        _list = [NSMutableArray array];
    }
}

- (NSDictionary *)toSearchParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[LYLogin sharedLogin].access_token forKey:@"access_token"];
    [params setValue:@(_willLoadMore ? _page + 1 : 1) forKey:@"page"];
    switch (self.type) {
        case LYCommentListTypeStatus:
            [params setObject:self.originalStatusID forKey:@"id"];
            break;
        case LYCommentListTypeShowBatch:
            [params setObject:self.commentIds forKey:@"cids"];
            break;
        case LYCommentListTypeAtMe_All:
        {
            
        }
            break;
        case LYCommentListTypeAtMe_Friends:
        {
            [params setValue:@1 forKey:@"filter_by_author"];
        }
            break;
        default:
            break;
    }
    return params;
}



@end
