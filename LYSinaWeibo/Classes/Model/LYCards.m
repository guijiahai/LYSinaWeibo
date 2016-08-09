//
//  LYCards.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYCards.h"

@implementation LYCardGroup

- (void)configWithData:(NSDictionary *)data {
    NSMutableArray *cards = [NSMutableArray array];
    for (NSDictionary *tmp in data[@"card_group"]) {
        LYCard *card = [LYCard mj_objectWithKeyValues:tmp];
        [cards addObject:card];
    }
    self.cards = [cards copy];
}

@end

@interface LYCard ()

@property (nonatomic, strong) NSString *desc1;

@end

@implementation LYCard

- (void)setDesc1:(NSString *)desc1 {
    _desc1 = desc1;
    _desc = desc1;
}

@end

@implementation LYCards


- (NSString *)toSearchPath {
    return @"http://api.weibo.cn/2/page?networktype=wifi&verified_type=&uicode=10000011&moduleID=708&c=android&i=f1c6047&s=8b4bbb03&ua=Meizu-m1%20metal__weibo__6.7.2__android__android5.1&wm=9848_0009&aid=01Al9NpMxB5LgX3P7mqsZIav6hfLqofRD6Qp-UUEd-DSkEIPQ.&fid=1005055982870440&v_f=2&v_p=32&from=1067295010&imsi=460016517502688&lang=zh_CN&nick=%E5%A4%A9%E4%BA%AE%E4%BB%A5%E5%90%8EG&skin=default&count=0&oldwm=9848_0009&sflag=1&cover_width=1080";
}

- (NSDictionary *)toSearchParams {
    return @{
             @"uid" : [LYLogin sharedLogin].uid,
             @"gsid" : LY_Gsid
             };
}

- (void)configWithData:(NSDictionary *)data {
    NSMutableArray *groups = [NSMutableArray array];
    for (NSDictionary *tmp in data[@"cards"]) {
        LYCardGroup *group = [[LYCardGroup alloc] init];
        [group configWithData:tmp];
        [groups addObject:group];
    }
    self.groups = [groups copy];
}

@end

