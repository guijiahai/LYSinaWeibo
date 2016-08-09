//
//  LYStatusList.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatusList.h"

@interface LYStatusList ()

@property (nonatomic, assign) LYStatusListType type;

@end

@implementation LYStatusList

+ (instancetype)statusListWithType:(LYStatusListType)type {
    LYStatusList *list = [[LYStatusList alloc] init];
    list.type = type;
    return list;
}

- (instancetype)init {
    if (self = [super init]) {
        _willLoadMore = NO;
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
    
    if (self.type == LYStatusListTypeRepostTimeline) {
        self.hot_reposts = [NSMutableArray array];
        if ([data[@"hot_reposts"] count] > 0) {
            [self.hot_reposts addObjectsFromArray:[LYStatus mj_objectArrayWithKeyValuesArray:data[@"hot_reposts"]]];
        }
        if ([data[@"reposts"] count] > 0) {
            [self.list addObjectsFromArray:[LYStatus mj_objectArrayWithKeyValuesArray:data[@"reposts"]]];
            _canLoadMore = YES;
        } else {
            _canLoadMore = NO;
        }
    } else {
        if ([data[@"statuses"] count] > 0) {
            [self.list addObjectsFromArray:[LYStatus mj_objectArrayWithKeyValuesArray:data[@"statuses"]]];
            _canLoadMore = YES;
        } else {
            _canLoadMore = NO;
        }
    }
}

- (void)loadFailed {
    _loadFailed = YES;
    if (!_list) {
        _list = [NSMutableArray array];
    }
}

- (NSString *)toInfoPath {
    switch (self.type) {
        case LYStatusListTypePublic:
            return @"/2/statuses/public_timeline.json";
        case LYStatusListTypeFriends:
//            return @"/2/statuses/friends_timeline.json";
            return @"/2/statuses/home_timeline.json";
        case LYStatusListTypeRepostTimeline:
//            return @"/2/statuses/repost_timeline.json";
            //利用新浪为openAPI无法获取到微博的转发列表，这里的地址是从手机客户端截取的，可能有失效时间
            return @"http://api.weibo.cn/2/statuses/repost_timeline?wm=3333_2001&i=2532d2a&b=1&from=1065193010&c=iphone&networktype=wifi&v_p=31&skin=default&v_f=1&s=7c301934&lang=zh_CN&sflag=1&ua=iPhone8,1__weibo__6.5.1__iphone__os9.2&aid=01AgNwb7_lwH_UAtR2XJa6S-VQrLETs9Egh6Rmk3TPoRbOTS4.&pagesize=20&luicode=10000001&featurecode=10000088&uicode=10000002&rid=0_1_8_2666928391699356577&fromlog=100011946304022&has_member=1&afr=ad&mark=1_1_115429CCF84FEC223A4430E230F2896613D63BAFC43DFC3198B0F9ED6791721EDA521E81EFB4729E0A9BC75CCF62A074F8CF856531B60FB52B527B6DD960AF3AD81D4A6C8F0043CE0C37EBAC087B6A9B882FFC2891F1EC3248AB694247ADD741F209CA6FC1C6DA481801215FD640973C&lfid=100011946304022&moduleID=feed";
            
            //&_status_id=3997215166962240&page=1&id=3997151744419727&mid=3997151744419727
        case LYStatusListTypeAtMe_All:
        case LYStatusListTypeAtMe_Friends:
        case LYStatusListTypeAtMe_Original:
            return @"/2/statuses/mentions.json";
            
        case LYStatusListTypeOfOther_All:
        case LYStatusListTypeOfOther_Original:
        case LYStatusListTypeOfOther_Picture:
            return @"/2/statuses/user_timeline.json";
    }
    return nil;
}

- (NSDictionary *)toInfoParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[LYLogin sharedLogin].access_token forKey:@"access_token"];
    [params setValue:@(_willLoadMore ? _page + 1 : 1) forKey:@"page"];
    switch (self.type) {
        case LYStatusListTypePublic:
        {
            
        }
            break;
        case LYStatusListTypeFriends:
        {

        }
            break;
        case LYStatusListTypeRepostTimeline:
        {
            [params setValue:self.originalStatusID forKey:@"id"];
            [params setValue:LY_Gsid forKey:@"gsid"];
        }
            break;
        case LYStatusListTypeAtMe_All:
        {
            
        }
            break;
        case LYStatusListTypeAtMe_Friends:
        {
            [params setValue:@1 forKey:@"filter_by_author"];
        }
            break;
        case LYStatusListTypeAtMe_Original:
        {
            [params setValue:@1 forKey:@"filter_by_type"];
        }
            break;
        case LYStatusListTypeOfOther_All:
        {
            [params setValue:self.otherUid forKey:@"uid"];
        }
            break;
        case LYStatusListTypeOfOther_Original:
        {
            [params setValue:@1 forKey:@"feature"];
            [params setValue:self.otherUid forKey:@"uid"];
        }
            break;
        case LYStatusListTypeOfOther_Picture:
        {
            [params setValue:@2 forKey:@"feature"];
            [params setValue:self.otherUid forKey:@"uid"];
        }
            break;
    }
    return [params copy];
}

@end
