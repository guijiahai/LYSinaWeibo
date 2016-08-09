//
//  NSDate+Common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Common)

- (NSInteger)secondsAgo;
- (NSInteger)minutesAgo;
- (NSInteger)hoursAgo;
- (NSInteger)daysAgo;
- (NSInteger)weeksAgo;
- (NSInteger)monthsAgo;
- (NSInteger)yearsAgo;

- (NSInteger)leftDaysAgo;
- (NSInteger)leftWeeksAgo;
- (NSInteger)leftMonthsAgo;
- (NSInteger)leftYearsAgo;

- (NSString *)stringDisplay_HHmm;
- (NSString *)stringDisplay_MMdd;
- (NSString *)stringDisplay_yyyy_MM_dd;

- (NSString *)stringWithFormat:(NSString *)format;

/**
 *  property
 */
- (NSInteger)second;
- (NSInteger)minute;
- (NSInteger)day;
- (NSInteger)weekday;
- (NSInteger)weekOfMonth;
- (NSInteger)weekOfYear;
- (NSInteger)month;
- (NSInteger)year;

- (NSString *)weekdayOfChinese;

/**
 * date start & end
 */
+ (NSDate *)startOfDayForDate:(NSDate *)date;
+ (NSDate *)endOfDayForDate:(NSDate *)date;

+ (NSDate *)startOfWeekForDate:(NSDate *)date;
+ (NSDate *)endOfWeekForDate:(NSDate *)date;

+ (NSDate *)startOfMonthForDate:(NSDate *)date;
+ (NSDate *)endOfMonthForDate:(NSDate *)date;

+ (NSDate *)startOfYearForDate:(NSDate *)date;
+ (NSDate *)endOfYearForDate:(NSDate *)date;

- (NSString *)systemString;

@end

@interface NSString (Date)

- (NSDate *)systemDate;

@end