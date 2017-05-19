//
//  NSDate+Time.m
//  WOEATAPP-KITCHEN
//
//  Created by Huang Yirong on 16/12/27.
//  Copyright © 2016年 com.woeat-inc. All rights reserved.
//

#import "NSDate+Time.h"

#define SECONDS_IN_MINUTE 60
#define MINUTES_IN_HOUR 60
#define DAYS_IN_WEEK 7
#define SECONDS_IN_HOUR (SECONDS_IN_MINUTE * MINUTES_IN_HOUR)
#define HOURS_IN_DAY 24
#define SECONDS_IN_DAY (HOURS_IN_DAY * SECONDS_IN_HOUR)

#define DEFAULT_CONVERSION_TYPE0             @"yyyy-MM-dd HH:mm:ss"
#define DEFAULT_CONVERSION_TYPE1            @"yyyy-MM-dd"

@implementation NSDate (Time)

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
//    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (NSDate *)dateTomorrow
{
    return [self dateWithDaysAfterNow:1];
}

+ (NSDate *)dateWithDaysAfterNow:(NSInteger)days
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self querySinceReferenceTime:(SECONDS_IN_DAY * days)]];
}

+ (NSTimeInterval)querySinceReferenceTime:(NSInteger)seconds
{
    NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate] + (seconds);
    return timeInterval;
}

+ (NSString *)stringWithNow
{
    return [self stringWithDate:[NSDate date]];
}

+ (NSString *)stringWithDate:(NSDate *)date
{
    return [self stringWithDate:date type:DEFAULT_CONVERSION_TYPE1];
}

+ (NSString *)stringWithNow:(NSString *)type
{
    return [self stringWithDate:[NSDate date] type:type];
}

+ (NSString *)stringWithDate:(NSDate *)date type:(NSString *)type
{
    return [[self queryDateFormatterEnglist:type] stringFromDate:date];
}

+ (NSDateFormatter *)queryDateFormatterEnglist:(NSString *)type
{
    NSDateFormatter *dateFormatter = [self queryDateFormatter:type];
    dateFormatter.locale =  [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return dateFormatter;
}

+ (NSDateFormatter *)queryDateFormatter:(NSString *)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:type];
    return dateFormatter;

}


@end
