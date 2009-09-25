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

+ (NSString *)formattedStatus;
+ (NSString *)totalTimeForSection:(NSMutableArray *)section withActive:(BOOL)active;

+ (NSString *)formattedProjectNameForTrackingInterval:(NSMutableDictionary *)pInterval;
+ (NSString *)formattedTimeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval decimal:(BOOL)decimal;
+ (NSString *)formattedStartTimeForTrackingInterval:(NSMutableDictionary *)pInterval;
+ (NSString *)formattedStopTimeForTrackingInterval:(NSMutableDictionary *)pInterval;


@end
