//
//  NSDate+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "NSDate+Common.h"

static NSString *const kLYSystemDateFormat = @"EEE MMM d HH:mm:ss Z yyyy";

@implementation NSDate (Common)

- (NSInteger)secondsAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitSecond) fromDate:self toDate:[NSDate date] options:0] second];
}

- (NSInteger)minutesAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitMinute) fromDate:self toDate:[NSDate date] options:0] minute];
}

- (NSInteger)hoursAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitHour) fromDate:self toDate:[NSDate date] options:0] hour];
}

- (NSInteger)daysAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitHour) fromDate:self toDate:[NSDate date] options:0] hour];
}

- (NSInteger)weeksAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitWeekOfYear) fromDate:self toDate:[NSDate date] options:0] weekOfYear];
}

- (NSInteger)monthsAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:self toDate:[NSDate date] options:0] month];
}

- (NSInteger)yearsAgo {
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:self toDate:[NSDate date] options:0] year];
}

- (NSInteger)leftDaysAgo {
    NSDate *today = [[NSCalendar currentCalendar] startOfDayForDate:[NSDate date]];
    NSDate *selfDay = [[NSCalendar currentCalendar] startOfDayForDate:self];
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:selfDay toDate:today options:0] day];
}

- (NSInteger)leftWeeksAgo {
    NSDate *selfWeekStart = [NSDate startOfWeekForDate:self];
    NSDate *toWeekStart = [NSDate startOfWeekForDate:[NSDate date]];
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitWeekOfYear) fromDate:selfWeekStart toDate:toWeekStart options:0] weekOfYear];
}

- (NSInteger)leftMonthsAgo {
    NSDate *selfMonthStart = [NSDate startOfMonthForDate:self];
    NSDate *toMonthStart = [NSDate startOfMonthForDate:[NSDate date]];
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:selfMonthStart toDate:toMonthStart options:0] month];
}

- (NSInteger)leftYearsAgo {
    NSDate *selfYearStart = [NSDate startOfYearForDate:self];
    NSDate *toYearStart = [NSDate startOfYearForDate:[NSDate date]];
    return [[[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:selfYearStart toDate:toYearStart options:0] year];
}

- (NSString *)stringDisplay_HHmm {
    if ([self leftYearsAgo] > 0) {
        return [self stringWithFormat:@"yyyy-MM-dd"];
    } else if ([self leftDaysAgo] > 0) {
        return [self stringWithFormat:@"MM-dd HH:mm"];
    } else if ([self hoursAgo] > 0) {
        return [self stringWithFormat:@"HH:mm"];
    } else if ([self minutesAgo] > 0) {
        NSString *display = [NSString stringWithFormat:@"%ld 分钟前", [self minutesAgo]];
        return display;
    } else {
        return @"刚刚";
    }
}

- (NSString *)stringDisplay_MMdd {
    if ([self leftYearsAgo] > 0) {
        return [self stringWithFormat:@"yyyy-MM-dd"];
    } else if ([self leftDaysAgo] > 3) {
        return [self stringWithFormat:@"MM-dd"];
    } else if ([self leftDaysAgo] > 2) {
        return @"前天";
    } else if ([self leftDaysAgo] > 1) {
        return @"昨天";
    } else if ([self hoursAgo] > 0) {
        return [self stringWithFormat:@"HH:mm"];
    } else if ([self minutesAgo] > 0) {
        NSString *display = [NSString stringWithFormat:@"%ld 分钟前", [self minutesAgo]];
        return display;
    } else {
        return @"刚刚";
    }
}

- (NSString *)stringDisplay_yyyy_MM_dd {
    return [self stringWithFormat:@"yyyy-MM-dd"];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSInteger)second {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitSecond fromDate:self];
}

- (NSInteger)minute {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMinute fromDate:self];
}

- (NSInteger)day {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:self];
}

- (NSInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    return [calendar component:NSCalendarUnitWeekday fromDate:self];
}

- (NSInteger)weekOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    return [calendar component:NSCalendarUnitWeekOfMonth fromDate:self];
}

- (NSInteger)weekOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    return [calendar component:NSCalendarUnitWeekOfYear fromDate:self];
}

- (NSInteger)month {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:self];
}

- (NSInteger)year {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self];
}

- (NSString *)weekdayOfChinese {
    switch ([self weekday]) {
        case 1:
            return @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return nil;
    }
}

+ (NSDate *)startOfDayForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    if (![[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return startDate;
}

+ (NSDate *)endOfDayForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    if (![[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return [startDate dateByAddingTimeInterval:interval];
}

+ (NSDate *)startOfWeekForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    if (![calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return startDate;
}
+ (NSDate *)endOfWeekForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];
    if (![calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return [startDate dateByAddingTimeInterval:interval];
}

+ (NSDate *)startOfMonthForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    if (![[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return startDate;
}

+ (NSDate *)endOfMonthForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    if (![[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return [startDate dateByAddingTimeInterval:interval];
}

+ (NSDate *)startOfYearForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    if (![[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitYear startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return startDate;
}

+ (NSDate *)endOfYearForDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval interval;
    if (![[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitYear startDate:&startDate interval:&interval forDate:date]) {
        return nil;
    }
    return [startDate dateByAddingTimeInterval:interval];
}

- (NSString *)systemString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kLYSystemDateFormat];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    return [dateFormatter stringFromDate:self];
}

@end

@implementation NSString (Date)

- (NSDate *)systemDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kLYSystemDateFormat];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

@end
