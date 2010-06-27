//
//  WTEngine.m
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  ***
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

- (BOOL)isRunning {
	return [model.active boolValue];
}

- (NSString *)formattedStatus {
	if ([self isRunning] && [model.activities count] > 0) {
		return [NSString stringWithFormat:NSLocalizedString(@"Tracking '%@'", @"Status, Currently tracking 'a project'"), [[model.activities objectAtIndex:0] objectForKey:cProject]];
	} else if ([model.projects count] == 0) {
		return NSLocalizedString(@"There are no projects...", @"Status, Inform the user that the are no projects");
	} else {
		// return [NSString stringWithFormat:@"Standby %@", cCharSleeping];
		return NSLocalizedString(@"Standby", @"Status, Ready and waiting");
	}
}

#pragma mark Start & stop tracking

- (void)startTrackingProject:(NSString *)projectName withComment:(NSString *)comment {
	model.active= [NSNumber numberWithBool:YES];
	[[WTSort sharedSortingModel] invalidateSectionsForSortingType:WTSortingAll];
	
	// Activity
	NSMutableDictionary *activity= [[NSMutableDictionary alloc] init];
	[activity setObject:[NSDate date] forKey:cStartTime];
	[activity setObject:projectName forKey:cProject];
	if (comment)[activity setObject:comment forKey:cComment];
	[model.activities insertObject:activity atIndex:0];
	[activity release];
	
	// Project
	NSMutableDictionary *project= [model.projects objectForKey:projectName];
	NSInteger numberOfIntervals= [[project objectForKey:cProjectNumber] intValue] + 1;
	[project setObject:[NSNumber numberWithInt:numberOfIntervals] forKey:cProjectNumber];
	
	// Notify models about the changes
	[model didChangeCollection:cActivities];
	[model didChangeCollection:cProjects];
}

- (void)stopTracking {
	model.active= [NSNumber numberWithBool:NO];
	
	NSMutableDictionary *activity= [model.activities objectAtIndex:0];
	[activity setObject:[NSDate date] forKey:cStopTime];
	NSDate *startTime= [activity objectForKey:cStartTime];
	NSTimeInterval timeInterval= -[startTime timeIntervalSinceNow];
	[activity setObject:[NSNumber numberWithDouble:timeInterval] forKey:cTimeInterval];
	
	NSMutableDictionary *project= [model.projects objectForKey:[activity objectForKey:cProject]];
	NSTimeInterval totalTimeInterval= [[project objectForKey:cProjectTime] doubleValue] + timeInterval;
	[project setObject:[NSNumber numberWithDouble:totalTimeInterval] forKey:cProjectTime];
	
	[model didChangeCollection:cActivities];
	[model didChangeCollection:cProjects];
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
