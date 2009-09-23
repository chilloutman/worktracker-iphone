//
//  WTEngine.m
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTEngine.h"
#import "WTDataModel.h"

#import "WTConstants.h"

static WTEngine *sharedInstace= nil;

@implementation WTEngine

+ (WTEngine *)sharedEngine {
	@synchronized(self) {
		if (sharedInstace == nil) {
			sharedInstace= [[self alloc] init];
		}
	}
	return sharedInstace;
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

#pragma mark Start & stop tracking

- (void)startTrackingProjectAtIndex:(NSInteger)index {
	model.status= cStatusRunning;
	
	NSMutableDictionary *activeInterval= [[NSMutableDictionary alloc] init];	
	[activeInterval setObject:[NSDate date] forKey:cStartTime];
	[activeInterval setObject:[NSNumber numberWithInt:0] forKey:cDayID];
	[activeInterval setObject:[model.projects objectAtIndex:index] forKey:cProject];
	
	[model.trackingIntervals insertObject:activeInterval atIndex:0];
	[activeInterval release];
	
	// Notify of changes
	[model didChangeCollection:cTrackingIntervals];
}

- (void)stopTracking {
	model.status= cStatusStandby;
	
	NSMutableDictionary *trackingInterval= [model.trackingIntervals objectAtIndex:0];
	
	[trackingInterval setObject:[NSDate date] forKey:cStopTime];
	[trackingInterval setObject:[NSNumber numberWithDouble:[model timeIntervalForTrackingInterval:nil]] forKey:cTimeInterval];
	
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
    return sharedInstace;
}

- (id)autorelease {
    return sharedInstace;
}

@end
