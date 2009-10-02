//
//  WTEngine.m
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTEngine.h"
#import "WTDataModel.h"
#import "WTSort.h"

#import "WTConstants.h"

static WTEngine *sharedEngine= nil;

@implementation WTEngine

+ (WTEngine *)sharedEngine {
	@synchronized(self) {
		if (sharedEngine == nil) {
			sharedEngine= [[self alloc] init];
		}
	}
	return sharedEngine;
}

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
	}
	return self;
}

- (BOOL)running {
	return [model.status isEqualToString:cStatusRunning];
}

- (NSString *)formattedStatus {
	if ([self running] && [model.trackingIntervals count] > 0) {
		return [NSString stringWithFormat:NSLocalizedString(@"Tracking '%@'", @"Status, Currently tracking 'a project'"), [[model.trackingIntervals objectAtIndex:0] objectForKey:cProject]];
	} else if ([model.projects count] == 0) {
		return NSLocalizedString(@"There are no projects...", @"Status, Inform the user that the are no projects");
	} else {
		// return [NSString stringWithFormat:@"Standby %@", cCharSleeping];
		return NSLocalizedString(@"Standby", @"Status, Ready and waiting");
	}
}

#pragma mark Start & stop tracking

- (void)startTrackingProjectAtIndex:(NSInteger)index {
	model.status= cStatusRunning;
	[[WTSort sharedSortingModel] invalidateSectionsForSortingType:WTSortingByAll];
	
	NSMutableDictionary *activeInterval= [[NSMutableDictionary alloc] init];
	[activeInterval setObject:[NSDate date] forKey:cStartTime];
	[activeInterval setObject:[model.projects objectAtIndex:index] forKey:cProject];
	
	[model.trackingIntervals insertObject:activeInterval atIndex:0];
	[activeInterval release];
	
	// Notify models about the changes
	[model didChangeCollection:cTrackingIntervals];
}

- (void)stopTracking {
	model.status= cStatusStandby;
	
	NSMutableDictionary *trackingInterval= [model.trackingIntervals objectAtIndex:0];
	
	[trackingInterval setObject:[NSDate date] forKey:cStopTime];
	NSDate *startTime= [trackingInterval objectForKey:cStartTime];
	[trackingInterval setObject:[NSNumber numberWithDouble:-[startTime timeIntervalSinceNow]] forKey:cTimeInterval];
	
	[model didChangeCollection:cTrackingIntervals];
}

#pragma mark Timer

- (void)pingEvery:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector identifier:(NSString *)key {
	if (!timers) {
		timers= [[NSMutableDictionary alloc] initWithCapacity:1]; // Makes no sence AT THE MOMENT
	}
	
	// Set up ONE timer and keep a reference
	if (![timers objectForKey:key]) {
		NSTimer *timer= [NSTimer scheduledTimerWithTimeInterval:interval target:aTarget selector:aSelector userInfo:nil repeats:YES];
		[timers setObject:timer forKey:key];
	}
}

- (void)stopPinging:(NSString *)key {
	NSTimer *timer= [timers objectForKey:key];
	
	if (timer) {
		[timer invalidate];
		[timers removeObjectForKey:key];
	}
}

#pragma mark -

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)retain {
    return sharedEngine;
}

- (id)autorelease {
    return sharedEngine;
}

@end
