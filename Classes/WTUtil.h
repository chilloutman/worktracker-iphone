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

// Stuff for the UI

+ (NSString *)dayForDate:(NSDate *)pDate;
+ (NSString *)weekForDate:(NSDate *)pDate;
+ (NSString *)monthForDate:(NSDate *)pDate;
+ (NSString *)timeForDate:(NSDate *)pDate;
+ (NSString *)dateForDate:(NSDate *)pDate;
+ (NSString *)formattedTimeInterval:(NSTimeInterval)pInterval decimal:(BOOL)decimal;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString *)totalTimeForSection:(NSMutableArray *)section withActive:(BOOL)active;
+ (NSString *)formattedProjectNameForTrackingInterval:(NSMutableDictionary *)pInterval running:(BOOL)running;
+ (NSString *)formattedStartTimeForTrackingInterval:(NSMutableDictionary *)pInterval;
+ (NSString *)formattedStopTimeForTrackingInterval:(NSMutableDictionary *)pInterval;

// Private

//+ (NSTimeInterval)timeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval;

@end
