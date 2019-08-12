//
//  DateCalculater.h
//  L2CSmartMotor
//
//  Created by feaonline on 2018/9/25.
//  Copyright © 2018年 feaonline. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DateCalculater : NSObject

+(NSDateFormatter *)fetDateFormatter;

+ (NSString *)startTimeFromDate:(NSDate *)date;

+ (NSString *)endTimeFromDate:(NSDate *)date time:(NSTimeInterval )time;

+ (NSDate *)dateFromDateString:(NSString *)dateString;

//am 或者pm
+(NSString *)fetchAMorPM:(NSDate *)date;

//2016-12-01->2016年12月01日
+ (NSString *)dateStrFromDateString:(NSString *)dateString;

+ (NSString *)dateStringOfToday;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)dateAndTimeStringFromDate:(NSDate *)date;

+ (NSDate *)dateAndTimeFromString:(NSString *)dateString;

+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSDate *)dateFromDate:(NSDate *)date;

+ (NSInteger)weekNumberOftheDateString:(NSString *)dateString;


+ (NSInteger )quarterNumberOfDate:(NSDate *)date;

+ (NSDate *)firstMonthDayOftheDay:(NSDate *)date;

+ (NSDate *)firstWeekDayOftheDay:(NSDate *)date;



+ (NSDate *)dateAfterYears:(NSInteger)yearsNumber toDate:(NSDate *)date;

+ (NSDate *)dateAfterMonths:(NSInteger)monthsNumber toDate:(NSDate *)date;

+ (NSDate *)dateAfterWeeks:(NSInteger)weeksNumber toDate:(NSDate *)date;

+ (NSDate *)dateAfterDays:(NSInteger)daysNumber toDate:(NSDate *)date;





+ (NSInteger)yearNumberOftheDate:(NSDate *)date;

+ (NSInteger)monthNumberOftheDate:(NSDate *)date;

+ (NSInteger)weekNumberOftheDate:(NSDate *)date;

+ (NSInteger)weekdayNumberOftheDate:(NSDate *)date;

+ (NSInteger)dayNumberOftheDate:(NSDate *)date;

+ (NSInteger)hourNumberOftheDate:(NSDate *)date;

+ (NSInteger)minuteNumberOftheDate:(NSDate *)date;




+ (NSString *)chineseMonthNumberOftheDate:(NSDate *)date;
+ (NSString *)chineseDayNumberOftheDate:(NSDate *)date;

+ (NSString *)chineseYearString:(NSInteger)yearNumber;

+ (NSString *)lunarYearString:(NSInteger)lunarYearNumber;

+ (NSString *)onlyTimeStringFromDate:(NSDate *)date;

+ (NSDate *)firstDayOftheMonth:(NSInteger)monthNumber andYear:(NSInteger)yearNumber;

//获取当月第一天和最后一天
+ (NSArray<NSDate *> *)fetchMonthFirstDayAndLastDay:(NSInteger)monthNumber andYear:(NSInteger)yearNumber;

+ (NSInteger)monthDaysOftheDay:(NSDate *)date;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;


//  Negative values indicate that fromDate is after toDate

+ (NSInteger)daysFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)weeksFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)monthsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)yearsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;


+ (NSArray *)getShortWeekdaySymbols;
+ (NSArray *)getShortMonthSymbols;


+ (NSString *)fetchWeekStringWith:(NSDate *)date;

//计算当前日历下的节气
+(NSString *)getLunarSpecialDate:(NSDate *)date;

//计算星座
+(NSString *)getConstellation:(NSDate *)date;

+ (NSString *)americaDate:(NSDate *)date ;
/**
 判断时间时是否在某时间范围内
 
 @param date 待判断时间
 @param startD 时间范围 - 开始时间
 @param endD 时间范围 - 结束时间
 @return 是否在范围内
 */
+ (BOOL)judgeTime:(NSDate *)date ByStartAndEnd:(NSDate *)startD EndTime:(NSDate *)endD;

+ (NSNumber *)JSTimeInwithDateStr:(NSString *)dateStr;
@end
