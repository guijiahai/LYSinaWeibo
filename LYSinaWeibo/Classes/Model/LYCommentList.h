//
//  LYCommentList.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/14.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYComment.h"

typedef NS_ENUM(NSInteger, LYCommentListType) {
    LYCommentListTypeStatus,            //某条微博的评论列表
    LYCommentListTypeByMe,              //我发出的评论列表
    LYCommentListTypeToMe,              //我收到的评论列表
    LYCommentListTypeTimeline,          //获取用户发送及收到的评论列表
    LYCommentListTypeShowBatch,         //批量获取评论的内容
    LYCommentListTypeAtMe_All,          //@我的评论 - 所有评论
    LYCommentListTypeAtMe_Friends,      //@我的评论 - 关注人的评论
};

@interface LYCommentList : NSObject

/* 当list为nil，表示还未从服务器上获取数据 */
@property (nonatomic, strong) NSMutableArray <LYComment *> *list;
@property (nonatomic, assign, readonly) LYCommentListType type;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) BOOL willLoadMore;
@property (nonatomic, readonly) BOOL canLoadMore;
@property (nonatomic, assign, getter=isLoading) BOOL loading;
@property (nonatomic, readonly, getter=isLoadFailed) BOOL loadFailed;

@property (nonatomic, strong) NSNumber *originalStatusID;   //微博ID
@property (nonatomic, strong) NSString *commentIds; //需要查询的批量评论的id，用半角逗号分隔


+ (instancetype)commentListWithType:(LYCommentListType)type;

- (void)configWithData:(NSDictionary *)data;
- (void)loadFailed;

- (NSString *)toSearchPath;
- (NSDictionary *)toSearchParams;

@end
