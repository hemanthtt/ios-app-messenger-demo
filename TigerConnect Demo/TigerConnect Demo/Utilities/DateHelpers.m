//
//  DateHelpers.m
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import "DateHelpers.h"

@implementation DateHelpers

+ (NSString *)relativeTimeStampFromDate:(NSDate *)date
{
    if (!date) return @"";
    
    NSDate * today = [NSDate date];
    NSTimeInterval timeInterval = [today timeIntervalSinceDate:date];
    BOOL isOlderThanOneDay = timeInterval > 60*60*24;
    BOOL isOlderThanOneWeek = timeInterval > 60*60*24*7;
    
    if (!isOlderThanOneDay) {
        return [DateHelpers convertDateToLocalTime:date];
    }
    
    if (isOlderThanOneWeek) {
        NSString *dateString = [DateHelpers convertDateToShortFormat:date];
        return dateString;
    }
    
    static NSDateFormatter* dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"EEEE"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)convertDateToLocalTime:(NSDate *)date
{
    if (!date) return @"";
    
    static NSDateFormatter* dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)convertDateToShortFormatWithTime:(NSDate *)date
{
    if (!date) return @"";
    
    static NSDateFormatter* dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd h:mm a"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)convertDateToShortFormat:(NSDate *)date
{
    if (!date) return @"";
    
    static NSDateFormatter* dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)messageExpireTimeString:(NSDate *)date
{
    if (!date) return @"";
    
    NSTimeInterval timeInterval = fabs([[NSDate date] timeIntervalSinceDate:date]);
    if (timeInterval <= 0) return @"";
    
    NSString *timeLeft = @"";
    
    if (timeInterval < 60) {
        //sec
        timeLeft = [NSString stringWithFormat:@"< 1 minute"];
        //        timeLeft = [NSString stringWithFormat:@"%.0f seconds left",timeInterval];
    }else if (timeInterval > 60 && timeInterval < 60 * 60) {
        //min
        timeLeft = [NSString stringWithFormat:@"%.0f minutes left",timeInterval/60];
    }else if (timeInterval > 60 * 60 && timeInterval < 60 * 60 * 24) {
        //hr
        timeLeft = [NSString stringWithFormat:@"%.0f hours left",timeInterval/(60 * 60)];
    }else if (timeInterval > 60 * 60 * 24) {
        //days
        timeLeft = [NSString stringWithFormat:@"%.0f days left",timeInterval/(60 * 60 * 24)];
    }
    return timeLeft;
}

+ (NSString *)convertSecondsToTimeString:(NSTimeInterval)totalSeconds {
    if (totalSeconds == 0) return @"00:00";
    
    NSInteger seconds = (NSInteger)totalSeconds % 60;
    NSInteger minutes = ((NSInteger)totalSeconds / 60) % 60;
    NSInteger hours = (NSInteger)totalSeconds / 3600;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
    }
    else {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
    }
}

@end
