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
	
	//if ([self.status isEqualToString:cStatusRunning]) {
//		[toKeep addObject:[self.trackingIntervals objectAtIndex:0]];
//	}
//	if (!all) {
//		for (int i= 0; i < [self.trackingIntervals count]; i++) {
//			NSMutableDictionary *currentInterval= [self.trackingIntervals objectAtIndex:i];
//			if ([[currentInterval objectForKey:cDayID] intValue] == 5) {
//				break;
//			} else {
//				[toKeep addObject:currentInterval];
//			}
//		}
//	}
	
	[self.trackingIntervals removeAllObjects];
	self.trackingIntervals= toKeep;
	
	// Notify
	[self didChangeCollection:cTrackingIntervals];
}

#pragma mark Getter

- (NSTimeInterval)timeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval {	
	// Get the newest interval if argument is nil
	if (pInterval == nil) {
		if ([self.trackingIntervals count] > 0) pInterval= [self.trackingIntervals objectAtIndex:0];
		else return 0.0;
	}
	
	NSNumber *timeInterval= [pInterval objectForKey:cTimeInterval];
	NSDate *startTime= [pInterval objectForKey:cStartTime];
	
	if (timeInterval) {
		// timeInterval is already set
		return [timeInterval doubleValue]; // NSTimeInterval == double
	} else if (startTime) {
		return [[NSDate date] timeIntervalSinceDate:startTime];
	}else {
		return 0.0;
	}
}

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
