//
//  LYStatus.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYStatus.h"
#import <hpple/TFHpple.h>

@interface LYStatus ()

@property (nonatomic, strong) NSString *source_parsed;

@end

@implementation LYStatus

@synthesize items = _items;

- (LYStatus *)retweeted_status {
    if (_retweeted_status) {
        _retweeted_status.retweeted = YES;
    }
    return _retweeted_status;
}

- (void)setPicViewSize:(CGSize)picViewSize {
    if (!CGSizeEqualToSize(_picViewSize, picViewSize)) {
        _picViewSize = picViewSize;
        _cellHeight = 0.0;  //重新计算
    }
}

- (NSString *)source {
    if (self.source_parsed) {
        return self.source_parsed;
    }
    
    if (_source) {
        
        NSData *data = [_source dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data];
        NSArray *array = [hpple searchWithXPathQuery:@"//a"];
        if (array.count > 0) {
            self.source_parsed = [NSString stringWithFormat:@"来自 %@", [(TFHppleElement *)array.firstObject text]];
        }
        return self.source_parsed;
    } else {
        return nil;
    }
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:NSStringFromSelector(@selector(user))]) {
        return [LYUser mj_objectWithKeyValues:oldValue];
    } else if ([property.name isEqualToString:NSStringFromSelector(@selector(geo))]) {
        return [LYGeo mj_objectWithKeyValues:oldValue];
    } else if ([property.name isEqualToString:NSStringFromSelector(@selector(retweeted_status))]) {
        return [LYStatus mj_objectWithKeyValues:oldValue];
    }
    return oldValue;
}

- (NSArray *)items {
    
    NSString *contentText = self.text ?: @"";
    if (self.retweeted) {
        contentText = [NSString stringWithFormat:@"@%@ :%@", self.user.screen_name, contentText];
    }
            
    NSMutableArray *mutableItems = [NSMutableArray array];

    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"#[^#]+#" options:NSRegularExpressionCaseInsensitive error:nil];
    if (regular) {
         NSArray *result = [regular matchesInString:contentText options:kNilOptions range:NSMakeRange(0, contentText.length)];
        if (result.count > 0) {
            [mutableItems addObjectsFromArray:result];
        }
    }
    
    regular = [NSRegularExpression regularExpressionWithPattern:@"@[\u4e00-\u9fa5a-zA-Z0-9_-]{4,30}" options:NSRegularExpressionCaseInsensitive error:nil];
    if (regular) {
        NSArray *result = [regular matchesInString:contentText options:kNilOptions range:NSMakeRange(0, contentText.length)];
        if (result.count > 0) {
            [mutableItems addObjectsFromArray:result];
        }
    }
    
    _items = [mutableItems copy];

    return _items;
}

@end
