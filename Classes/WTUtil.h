//
//  WTUtil.h
//  WorkTracker
//
//  Created by Lucas Neiva on 28.07.09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTUtil : NSObject {
	
}

// Stuff for the UI

+ (NSString *)dayForDate:(NSDate *)pDate;
+ (NSString *)weekForDate:(NSDate *)pDate;
+ (NSString *)monthForDate:(NSDate *)pDate;
+ (NSString *)timeForDate:(NSDate *)pDate;
+ (NSString *)dateForDate:(NSDate *)pDate;
+ (NSString *)shortDateForDate:(NSDate *)pDate;
+ (NSString *)formattedTimeInterval:(NSTimeInterval)pInterval decimal:(BOOL)decimal;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSTimeInterval)totalTimeForIntervals:(NSArray *)intervals;
+ (NSString *)formattedTotalTimeForIntervals:(NSArray *)section withActive:(BOOL)active;
+ (NSString *)formattedProjectNameForActivity:(NSMutableDictionary *)pInterval running:(BOOL)running;
+ (NSString *)formattedStartTimeForActivity:(NSMutableDictionary *)pInterval;
+ (NSString *)formattedStopTimeForActivity:(NSMutableDictionary *)pInterval;

// Caches

+ (NSDateFormatter *)dateFormatter;
+ (NSDateFormatter *)timeFormatter;
+ (NSCalendar *)calendar;
//+ (NSTimeInterval)timeIntervalForActivity:(NSMutableDictionary *)pActivity;

@end
