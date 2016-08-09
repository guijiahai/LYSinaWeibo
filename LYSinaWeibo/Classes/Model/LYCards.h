//
//  LYCards.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/26.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYCard, LYCardGroup;

@interface LYCards : NSObject

@property (nonatomic, strong) NSArray <LYCardGroup *> *groups;

- (NSString *)toSearchPath;
- (NSDictionary *)toSearchParams;

- (void)configWithData:(NSDictionary *)data;

@end

@interface LYCardGroup : NSObject

@property (nonatomic, strong) NSArray <LYCard *> *cards;

@end

@interface LYCard : NSObject

@property (nonatomic, strong) NSNumber *bold;
@property (nonatomic, strong) NSNumber *card_type;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *desc_extr;
@property (nonatomic, strong) NSNumber *display_arrow;
@property (nonatomic, strong) NSString *itemid;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *scheme;
@property (nonatomic, strong) NSNumber *sub_type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *unread_id;

@end
