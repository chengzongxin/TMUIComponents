//
//  NSDate+TMUI.m
//  TMUIKit
//
//  Created by Joe.cheng on 2021/1/27.
//

#import "NSDate+TMUI.h"

@implementation NSDate (TMUI)


- (NSInteger)tmui_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)tmui_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)tmui_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)tmui_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)tmui_minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)tmui_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)tmui_nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)tmui_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)tmui_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)tmui_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)tmui_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)tmui_yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)tmui_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)tmui_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)tmui_isLeapYear {
    NSUInteger year = self.tmui_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)tmui_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].tmui_day == self.tmui_day;
}

- (BOOL)tmui_isYesterday {
    NSDate *added = [self tmui_dateByAddingDays:1];
    return [added tmui_isToday];
}

- (NSDate *)tmui_dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)tmui_dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)tmui_dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)tmui_dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)tmui_dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)tmui_dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)tmui_dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSString *)tmui_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)tmui_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)tmui_stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

- (NSString *)tmui_stringWithDateFormatYMD{
    return [self tmui_stringWithFormat:kTMUIDateFormatYMD];
}

- (NSString *)tmui_stringWithDateFormatYMDHMS{
    return [self tmui_stringWithFormat:kTMUIDateFormatYMDHMS];
}

+ (NSDate *)tmui_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)tmui_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)tmui_dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}


//????????????NSDateFormatter????????????????????????????????????????????????????????????????????????????????????
+ (NSDateFormatter *)tmui_sharedDateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *instanceFormatter = nil;
    dispatch_once(&onceToken, ^{
        instanceFormatter = [[NSDateFormatter alloc] init];
        //[instanceFormatter setLocale:[NSLocale systemLocale]];
        //[instanceFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return instanceFormatter;
}

/// ?????????
+ (NSInteger)tmui_year:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.year;
}

/// ?????????
+ (NSInteger)tmui_month:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.month;
}


/// ????????????
+ (NSInteger)tmui_week:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:startDate];
    return components.weekday - 1;
}

/// ???????????? ??????
+ (NSString *)tmui_getWeekFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    NSInteger week = components.weekday - 1;
    NSDictionary *weekDic = @{@"0":@"???",@"1":@"???",@"2":@"???",@"3":@"???",@"4":@"???",@"5":@"???",@"6":@"???"};
    NSString *key = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[key];
}

/// ??????????????????
+ (NSString *)tmui_getChineseWeekFrom:(NSString *)dateStr {
    NSDictionary *weekDic = @{@"0":@"??????",@"1":@"??????",@"2":@"??????",@"3":@"??????",@"4":@"??????",@"5":@"??????",@"6":@"??????"};
    NSInteger week = [NSDate tmui_week:dateStr];
    NSString *weekKey = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[weekKey];
}

/// ?????????
+ (NSInteger)tmui_day:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *startDate = [dateFormatter dateFromString:dateStr];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:startDate];
    return components.day;
}

/// ????????????????????????
+ (NSInteger)tmui_daysInMonth:(NSString *)dateStr {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate tmui_timeIntervalFromDateString:dateStr] / 1000];
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

//??????????????????
+ (NSString *)tmui_currentDay {
    NSDateFormatter *formater = [self tmui_sharedDateFormatter];
    NSDate *date = [NSDate date];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * time = [formater stringFromDate:date];
    return time;
}

//??????????????????
+ (NSString *)tmui_currentHour {
    NSDateFormatter *formater = [self tmui_sharedDateFormatter];
    NSDate *curDate = [NSDate date];
    [formater setDateFormat:@"H:mm"];
    NSString * curTime = [formater stringFromDate:curDate];
    return curTime;
}

//??????????????????????????????~ ????????????????????????????????????????????????????????????????????????????????????
+ (NSString *)tmui_nextMonthLastDay {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    //????????????1???
    dateComponents.day =1;
    //?????????????????????2??????
    dateComponents.month +=2;
    NSDate * endDayOfNextMonth = [calendar dateFromComponents:dateComponents];
    //???????????????1????????????1?????????????????????????????????
    endDayOfNextMonth = [endDayOfNextMonth dateByAddingTimeInterval:-1];
    //???????????????
    NSDateFormatter *formater = [self tmui_sharedDateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:endDayOfNextMonth];
    return curTime;
}

///?????????????????????
+ (BOOL)tmui_isToday:(NSString *)dateStr {
    BOOL isDay = NO;
    NSString *day = [NSDate tmui_timeStringWithInterval:[NSDate date].timeIntervalSince1970];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

///?????????????????????
+ (BOOL)tmui_isTomorrow:(NSString *)dateStr {
    BOOL isDay = NO;
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 24 * 3600;
    NSString *day = [NSDate tmui_timeStringWithInterval:time];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

///?????????????????????
+ (BOOL)tmui_isAfterTomorrow:(NSString *)dateStr {
    BOOL isDay = NO;
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 48 * 3600;
    NSString *day = [NSDate tmui_timeStringWithInterval:time];
    if ([dateStr isEqualToString:day]) {
        isDay = YES;
    }
    return isDay;
}

/// ??????????????????????????????
+ (BOOL)tmui_isHistoryTime:(NSString *)dateStr {
    BOOL activity = NO;
    NSTimeInterval timeInterval = [NSDate tmui_timeIntervalFromDateString: dateStr];
    NSTimeInterval currentInterval = [NSDate tmui_timeIntervalFromDateString:[NSDate tmui_currentDay]];
    if (timeInterval < currentInterval) {
        activity = YES;
    }
    return activity;
}

/// ?????????????????????????????? ??????:6:00
+ (NSString *)tmui_hourStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"H:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

/// ?????????????????????????????? ??????:6
+ (NSString *)tmui_hourTagWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"H"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/// ??????????????????????????????????????? ??????:600
+ (NSString *)tmui_hourNumberWithInterval:(NSTimeInterval)timeInterval {
    NSString *hourStr = [self tmui_hourStringWithInterval:timeInterval / 1000];
    NSString *hourNumber = [hourStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    return hourNumber;
}

/// ?????????????????????????????? ??????:2018-03-05
+ (NSString *)tmui_timeStringWithInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/// ?????????????????????????????????(??????)
+ (NSTimeInterval)tmui_timeIntervalFromDateString:(NSString *)dateStr {
    //??????????????????2018-01-01 ??? 2018-01-01 00:00 ???????????????2018-01-01 00:00:00
    if (dateStr.length == 10) {
        dateStr = [dateStr stringByAppendingString:@" 00:00:00"];
    } else if (dateStr.length == 16) {
        dateStr = [dateStr stringByAppendingString:@":00"];
    }
    NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSTimeInterval interval = [date timeIntervalSince1970] * 1000;
    return interval;
}

/// ????????????????????????????????????
+ (NSString *)tmui_getWeekAfterDay:(NSInteger)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:[NSDate date]];
    NSInteger currentWeek = components.weekday - 1;
    NSDictionary *weekDic = @{@"0":@"???",@"1":@"???",@"2":@"???",@"3":@"???",@"4":@"???",@"5":@"???",@"6":@"???"};
    NSInteger week = currentWeek + day;
    if (week >= 7) {
        week -= 7;
    }
    NSString *key = [NSString stringWithFormat:@"%ld",(long)week];
    return weekDic[key];
}


/// ?????????????????????????????????
+ (NSString *)tmui_getDayAfterDay:(NSInteger)day {
    NSTimeInterval time = [NSDate date].timeIntervalSince1970 + 24 * 3600 * day;
    NSString *date = [NSDate tmui_timeStringWithInterval:time];
    NSInteger dayNum = [self tmui_day:date];
    NSString *dayStr = [NSString stringWithFormat:@"%ld",(long)dayNum];
    return dayStr;
}

/// ???????????????????????????
+ (NSString *)tmui_getMonthAfterMonth:(NSInteger)Month {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [self tmui_sharedDateFormatter];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1??????1??????????????? year = -1???1??????????????????month day ??????
    [lastMonthComps setMonth:Month];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}

//NSString???NSDate
+ (NSDate *)tmui_dateFromString:(NSString *)dateString formatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [NSDate tmui_sharedDateFormatter];
    [dateFormatter setDateFormat: (formatter == nil || formatter.length == 0) ? @"yyyy-MM-dd" : formatter];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}


//NSDate???NSString
+ (NSString *)tmui_stringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [NSDate tmui_sharedDateFormatter];
    
    //zzz???????????????zzz?????????????????????????????????????????????????????????????????????
    [dateFormatter setDateFormat:(formatter == nil || formatter.length == 0) ? @"yyyy-MM-dd" : formatter];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

//???????????????????????????
+ (NSString *)tmui_getWeekStringFromInteger:(NSInteger)week
{
    NSString *str_week = nil;
    
    switch (week) {
        case 1:
            str_week = @"??????";
            break;
        case 2:
            str_week = @"??????";
            break;
        case 3:
            str_week = @"??????";
            break;
        case 4:
            str_week = @"??????";
            break;
        case 5:
            str_week = @"??????";
            break;
        case 6:
            str_week = @"??????";
            break;
        case 7:
            str_week = @"??????";
            break;
    }
    return str_week;
}

//???????????????????????????
- (NSUInteger)tmui_numberOfDaysInCurrentMonth {
    
    // ???????????? [NSCalendar currentCalendar] ????????????????????????
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}


//???????????????????????????
- (NSUInteger)tmui_numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self tmui_firstDayOfCurrentMonth] tmui_weeklyOrdinality];
    NSUInteger days = [self tmui_numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1;
        days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}



/*???????????????????????????????????????*/
- (NSUInteger)tmui_weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:self];
}



//?????????????????????????????????
- (NSDate *)tmui_firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

//??????????????????????????????
- (NSDate *)tmui_lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self tmui_numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//?????????????????????
- (NSDateComponents *)tmui_YMDComponents
{
    return [[NSCalendar currentCalendar] components:
            NSCalendarUnitYear|
            NSCalendarUnitMonth|
            NSCalendarUnitDay|
            NSCalendarUnitWeekday fromDate:self];
}

//????????????1??????????????????2???...
- (NSInteger)tmui_getWeekIntValue
{
    NSInteger weekIntValue;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps= [calendar components:(NSCalendarUnitYear |
                                                   NSCalendarUnitMonth |
                                                   NSCalendarUnitDay |
                                                   NSCalendarUnitWeekday) fromDate:self];
    return weekIntValue = [comps weekday];
}

//???????????????
- (BOOL)tmui_isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unit = NSCalendarUnitYear;
    // 1.??????????????????????????????
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.??????self????????????
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
    
}

//????????????????????????
+ (NSString *)tmui_formatMessageDateFromInterval:(long long)interval {
    NSDateFormatter *dateFormatter = [NSDate tmui_sharedDateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    if ([NSDate tmui_isToday:dayStr]) {
        //??????
        dateFormatter.dateFormat = @"HH:mm";
        return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    }else{
        //?????????s
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
        BOOL isThisYear = [date tmui_isThisYear];
        if (isThisYear) {
            //??????
            dateFormatter.dateFormat = @"MM-dd";
            return  [dateFormatter stringFromDate:date];
        }
    }
    return dayStr;
}


///???????????????????????????
+ (NSString *)tmui_formatLivePreviewDateFromInterval:(NSTimeInterval)timeInterval isShowHour:(BOOL *)isShowHour{
    NSTimeInterval nowTimeInterval = [NSDate date].timeIntervalSince1970;
    NSTimeInterval interval = timeInterval - nowTimeInterval;
    if (interval < (24 * 3600)){
        //???????????????
        
        *isShowHour = YES;
        int hours = (int)(interval/3600);
        int minute = (int)(interval - hours * 3600)/60;
        if (hours < 0) {
            hours = 0;
        }
        if (minute < 0) {
            minute = 0;
        }
        return [NSString stringWithFormat:@"%d??????%d??????",hours,minute];
    }else{

        NSDateFormatter *dateFormatter = [self tmui_sharedDateFormatter];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dayStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
        return dayStr;
    }

    return nil;
}



/**
 *  ????????????NSDate??????????????????
 *
 *  @param date ???self?????????date
 *
 *  @return ????????????
 */
- (BOOL)tmui_isSameDay:(NSDate *)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    return [comp1 day]   == [comp2 day] &&
    
    [comp1 month] == [comp2 month] &&
    
    [comp1 year]  == [comp2 year];
}

- (BOOL)tmui_isSameMonth:(NSDate *)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    return [comp1 month] == [comp2 month] &&[comp1 year]  == [comp2 year];

}

-(NSDateComponents *)tmui_createDateComponentsWithYMD{
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    return components;
}

- (NSDate *)tmui_dateWithSampleWithYMD{
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *com = [self tmui_createDateComponentsWithYMD];
    return [calender dateFromComponents:com];
}

@end


@implementation NSDate (TMUI_Extensions)

//????????????
- (NSDate *)tmui_dayInThePreviousMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//????????????
- (NSDate *)tmui_dayInTheFollowingMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


//????????????????????????????????????
- (NSDate *)tmui_dayInTheFollowingMonth:(NSInteger)month
{
    if (month == 0) {
        return self;
    }
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//?????????????????????????????????
- (NSDate *)tmui_dayInTheFollowingDay:(NSInteger)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


+ (NSInteger)tmui_getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//??????????????????
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:today toDate:beforday options:0];
    //    NSDateComponents *components = [calendar components:NSMonthCalendarUnit|NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//?????????????????????????????????//    NSInteger days = [components day];//????????????????????????
    return day;
}

//?????????????????????,??????,??????,??????
- (NSString *)tmui_compareIfTodayWithDate
{
    NSDate *todate = [NSDate date];//??????
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps_today= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSCalendarUnitYear |
                                                         NSCalendarUnitMonth |
                                                         NSCalendarUnitDay |
                                                         NSCalendarUnitWeekday) fromDate:self];
    
    
    //???????????????????????????
    NSInteger weekIntValue = [self tmui_getWeekIntValue];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"??????";
        
    }
//7.13????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
//    else if (comps_today.year == comps_other.year &&
//              comps_today.month == comps_other.month &&
//              (comps_today.day - comps_other.day) == -1){
//        return @"??????";
//
//    } else if (comps_today.year == comps_other.year &&
//              comps_today.month == comps_other.month &&
//              (comps_today.day - comps_other.day) == -2){
//        return @"??????";
//
//    }
    else {
        //????????????????????????????????????(?????????????????????)
        return [NSDate tmui_getWeekStringFromInteger:weekIntValue];//??????
    }
}

@end
