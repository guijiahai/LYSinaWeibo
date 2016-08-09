//
//  LYStatusList.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYStatus.h"

typedef NS_ENUM(NSInteger, LYStatusListType) {
    LYStatusListTypePublic,             //最新的公共微博
    LYStatusListTypeFriends,            //当前登录用户及其所关注用户的最新微博
    LYStatusListTypeRepostTimeline,     //获取指定微博的转发微博列表
    LYStatusListTypeAtMe_All,           //@我的微博 - 所有微博
    LYStatusListTypeAtMe_Friends,       //@我的微博 - 关注人的微博
    LYStatusListTypeAtMe_Original,      //@我的微博 - 原创微博
    
    /* 需要otherUid, 如果是自己的，则不用传 */
    LYStatusListTypeOfOther_All,        //某人的微博 - 全部
    LYStatusListTypeOfOther_Original,   //某人的微博 - 原创
    LYStatusListTypeOfOther_Picture     //某人的微博 - 图片
};

@interface LYStatusList : NSObject

/* 当list为nil，表示还未从服务器上获取数据 */
@property (nonatomic, strong) NSMutableArray <LYStatus *> *list;

/* LYStatusListTypeRepostTimeline : 仅限于获取微博的转发微博列表 */
@property (nonatomic, strong) NSMutableArray <LYStatus *> *hot_reposts;

@property (nonatomic, assign) NSInteger page;   //当前的页码，开始为1
@property (nonatomic, strong) NSNumber *originalStatusID;   //要查询的微博ID
@property (nonatomic, strong) NSString *otherUid;   //获取某人的微博
@property (nonatomic, assign) BOOL willLoadMore;
@property (nonatomic, readonly) BOOL canLoadMore;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, readonly, getter=isLoadFailed) BOOL loadFailed;

+ (instancetype)statusListWithType:(LYStatusListType)type;

- (void)configWithData:(NSDictionary *)data;
- (void)loadFailed;

- (NSString *)toInfoPath;
- (NSDictionary *)toInfoParams;

@end
