//
//  WTUtil.h
//  WorkTracker
//
//  Created by Lucas Neiva on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTUtil : NSObject {
	
}

// Strings for the UI

+ (NSString *)dayForDate:(NSDate *)pDate;
+ (NSString *)weekForDate:(NSDate *)pDate;
+ (NSString *)monthForDate:(NSDate *)pDate;
+ (NSString *)timeForDate:(NSDate *)pDate;
+ (NSString *)dateForDate:(NSDate *)pDate;

+ (NSString *)totalTimeForSection:(NSMutableArray *)section withActive:(BOOL)active;

+ (NSString *)formattedProjectNameForTrackingInterval:(NSMutableDictionary *)pInterval running:(BOOL)running;
+ (NSString *)formattedTimeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval decimal:(BOOL)decimal;
+ (NSString *)formattedStartTimeForTrackingInterval:(NSMutableDictionary *)pInterval;
+ (NSString *)formattedStopTimeForTrackingInterval:(NSMutableDictionary *)pInterval;

// Private

+ (NSTimeInterval)timeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval;

@end
