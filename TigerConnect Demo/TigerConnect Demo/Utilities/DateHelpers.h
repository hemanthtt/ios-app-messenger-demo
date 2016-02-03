//
//  DateHelpers.h
//  TigerConnect Demo
//
//  Created by Oren Zitoun on 2/2/16.
//  Copyright © 2016 TigerText. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelpers : NSObject

+ (NSString *)convertDateToShortFormat:(NSDate *)date;
+ (NSString *)convertDateToShortFormatWithTime:(NSDate *)date;
+ (NSString *)convertDateToLocalTime:(NSDate *)date;
+ (NSString *)relativeTimeStampFromDate:(NSDate *)date;
+ (NSString *)messageExpireTimeString:(NSDate *)date;
+ (NSString *)convertSecondsToTimeString:(NSTimeInterval)totalSeconds;

@end
