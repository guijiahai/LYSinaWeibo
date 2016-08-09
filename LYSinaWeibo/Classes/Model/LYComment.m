//
//  LYComment.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComment.h"
#import "LYStatus.h"

@implementation LYComment

@synthesize items = _items;

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:NSStringFromSelector(@selector(user))]) {
        return [LYUser mj_objectWithKeyValues:oldValue];
    } else if ([property.name isEqualToString:NSStringFromSelector(@selector(status))]) {
        return [LYStatus mj_objectWithKeyValues:oldValue];
    } else if ([property.name isEqualToString:NSStringFromSelector(@selector(reply_comment))]) {
        return [LYComment mj_objectWithKeyValues:oldValue];
    }
    return oldValue;
}

- (NSArray<NSTextCheckingResult *> *)items {
    if (!_items) {
        
        NSMutableArray *mutableItems = [NSMutableArray array];
        
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"#[^#]+#" options:NSRegularExpressionCaseInsensitive error:nil];
        if (regular) {
            NSArray *result = [regular matchesInString:self.text options:kNilOptions range:NSMakeRange(0, self.text.length)];
            if (result.count > 0) {
                [mutableItems addObjectsFromArray:result];
            }
        }
        
        regular = [NSRegularExpression regularExpressionWithPattern:@"@[\u4e00-\u9fa5a-zA-Z0-9_-]{4,30}" options:NSRegularExpressionCaseInsensitive error:nil];
        if (regular) {
            NSArray *result = [regular matchesInString:self.text options:kNilOptions range:NSMakeRange(0, self.text.length)];
            if (result.count > 0) {
                [mutableItems addObjectsFromArray:result];
            }
        }

        _items = [mutableItems copy];
    }
    return _items;
}

@end
