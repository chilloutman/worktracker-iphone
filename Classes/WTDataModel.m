//
//  WTDataModel.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTDataModel.h"
#import "WTUtil.h"

#import "WTConstants.h"

static WTDataModel *sharedInstace= nil;

@implementation WTDataModel

+ (WTDataModel *)sharedDataModel {
	@synchronized(self) {
		if (sharedInstace == nil) {
			sharedInstace= [[self alloc] init];
		}
	}
	return sharedInstace;
}

@synthesize status;
@synthesize projects;
@synthesize trackingIntervals;

- (id)init {
	if (self= [super init]) {
		// Load saved data
		NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
		
		self.status= [userDefaults objectForKey:cStatus];
		if (self.status == nil) {
			self.status= cStatusStandby;
		}
		[self addObserver:self forKeyPath:cStatus options:0 context:NULL];
		
		self.projects= [NSMutableArray arrayWithArray:[userDefaults objectForKey:cProjects]];
		
		self.trackingIntervals= [NSMutableArray arrayWithArray:[userDefaults objectForKey:cTrackingIntervals]];
	}
	
	return self;
}

#pragma mark KVO / Saving data

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)c {
	NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
	
	// Save whaterver object just changed
	[userDefaults setObject:[object valueForKey:keyPath] forKey:keyPath];
}

// Manual implementation of KVO because Apple's KVO fails when using collections
- (void)didChangeCollection:(NSString *)keyPath {
	NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
	
	// Save whaterver object just changed
	[userDefaults setObject:[self valueForKey:keyPath] forKey:keyPath];
}

#pragma mark Delete data

- (void)deleteTrackingIntervals:(BOOL)all {
	NSMutableArray *toKeep= [NSMutableArray array];
	
	if ([self.status isEqualToString:cStatusRunning]) {
		[toKeep addObject:[self.trackingIntervals objectAtIndex:0]];
	}
	if (!all) {
		for (int i= 0; i < [self.trackingIntervals count]; i++) {
			NSMutableDictionary *currentInterval= [self.trackingIntervals objectAtIndex:i];
			if ([[currentInterval objectForKey:cDayID] intValue] == 5) {
				break;
			} else {
				[toKeep addObject:currentInterval];
			}
		}
	}
	
	[self.trackingIntervals removeAllObjects];
	self.trackingIntervals= toKeep;
	
	[self didChangeCollection:cTrackingIntervals];
}

#pragma mark Return processed values

- (NSTimeInterval)timeIntervalForTrackingInterval: (NSMutableDictionary *)pInterval {
	// Get the newest interval if property is nil
	if (pInterval == nil) {
		if (self.trackingIntervals) pInterval= [self.trackingIntervals objectAtIndex:0];
	}
	
	NSDate *startDate= [pInterval objectForKey:cStartTime];
	NSNumber *timeInterval= [pInterval objectForKey:cTimeInterval];
	
	if (timeInterval) {
		// timeInterval is already set
		return [timeInterval doubleValue]; // NSTimeInterval == double
	} else if (startDate) {
		return [[NSDate date] timeIntervalSinceDate:startDate];
	} else {
		return 0.0;
	}
}

- (NSString *)formattedTotalTimeForDay: (NSInteger)dayID withActive:(BOOL)active {
	NSTimeInterval total= 0;
	
	// Sum all time intervals
	for (int i= 0; i < [self.trackingIntervals count]; i++) {
		NSMutableDictionary *curTrackingInterval= [self.trackingIntervals objectAtIndex:i];
		NSInteger curDayID= [[curTrackingInterval objectForKey:cDayID] intValue];
		
		if (curDayID == dayID) {
			total+= [self timeIntervalForTrackingInterval:curTrackingInterval];
		} else if (curDayID > dayID) {
			break;
		}
	}
	
	if (!active && [self.status isEqualToString:cStatusRunning]) {
		// Don't count the Interval that is still running
		total-= [self timeIntervalForTrackingInterval:[self.trackingIntervals objectAtIndex:0]];
	}
	
	if (total > 0) {
		return [NSString stringWithFormat:@"%.2f h", total / 3600];
	} else {
		return nil;
	}
}

- (NSString *)formattedStatus {
	if ([self.status isEqualToString:cStatusRunning] && [self.trackingIntervals count] > 0) {
		return [NSString stringWithFormat:NSLocalizedString(@"Tracking '%@'", @"Status, Currently tracking 'a project'"), [[self.trackingIntervals objectAtIndex:0] objectForKey:cProject]];
	} else if ([self.projects count] == 0) {
		return NSLocalizedString(@"There are no projects...", @"Status, Inform the user that the are no projects");
	} else {
		// return [NSString stringWithFormat:@"Standby %@", cCharSleeping];
		return NSLocalizedString(@"Standby", @"Status, Ready and waiting");
	}
}

- (NSString *)formattedStartTimeForTrackingInterval: (NSMutableDictionary *)pInterval {
	// Use the newest intervall if parameter is nil
	if (pInterval == nil && [self.trackingIntervals count] > 0) {
		pInterval= [self.trackingIntervals objectAtIndex:0];
	}
	if (![self.status isEqualToString:cStatusRunning]) {
		return @"-";
	}
	if (pInterval == nil) return nil;
	
	NSDate *startDate= [pInterval objectForKey:cStartTime];
	if (startDate == nil) return @"-";
	
	// Return formatted Time
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:startDate];
}

- (NSString *)formattedStopTimeForTrackingInterval: (NSMutableDictionary *)pInterval {
	if (pInterval == nil) {
		if ([self.trackingIntervals count] > 0) pInterval= [self.trackingIntervals objectAtIndex:0];
		else return nil;
	}
	
	NSDate *stopTime= [pInterval objectForKey:cStopTime];
	if (stopTime == nil) return @"-";
	
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:stopTime];
}

- (NSString *)formattedTimeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval decimal:(BOOL)decimal  {
	if (pInterval == nil) {
		if ([self.trackingIntervals count] > 0) pInterval= [self.trackingIntervals objectAtIndex:0];
		else return nil;
	}
	
	// Format timeInterval
	if (decimal) {
		double hours= [self timeIntervalForTrackingInterval:pInterval] / 3600;
		NSString *timeInterval= [NSString stringWithFormat:@"%.3lf h", hours];
		
//		if (pInterval == [self.trackingIntervals objectAtIndex:0] && [self.status isEqualToString:cStatusRunning]) {
//			return [NSString stringWithFormat:@"%C %@", 'A', timeInterval];
//		}
		return timeInterval;
			
	} else {
		return @"This was not yet implemented";
	}
}

- (NSString *)formattedProjectNameForTrackingInterval:(NSMutableDictionary *)pInterval {
	if (pInterval == nil) {
		return nil;
	}
	
	if ([self.status isEqualToString:cStatusRunning] && pInterval == [self.trackingIntervals objectAtIndex:0]) {
		return [NSString stringWithFormat:@"%@ %@", cCharCircleGreen, [pInterval objectForKey:cProject]];
	} else {
		return [pInterval objectForKey:cProject];
	}
}


#pragma mark Formatters
	
//+ (NSDateFormatter *)startStopTimeFormatter {
//	static NSDateFormatter
//}

#pragma mark -

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)retain {
    return sharedInstace;
}

- (id)autorelease {
    return sharedInstace;
}

@end
