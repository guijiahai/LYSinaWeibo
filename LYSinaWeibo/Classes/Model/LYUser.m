//
//  LYUser.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/2.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYUser.h"

@implementation LYUser

//+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return @{@"description_" : @"description"};
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"description_" : @"description",
             @"idStr" : @"idstr"};
}

+ (NSString *)toInfoPath {
    return @"/2/users/show.json";
}

- (NSDictionary *)toInfoParams {
    return nil;
}

@end
