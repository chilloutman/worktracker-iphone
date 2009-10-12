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

@synthesize active;
@synthesize projects;
@synthesize trackingIntervals;

- (id)init {
	if (self= [super init]) {
		// Load saved data
		NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
		
		self.active= [userDefaults objectForKey:cStatus];
		if (!self.active) {
			self.active= [NSNumber numberWithBool:NO];
		}
		[self addObserver:self forKeyPath:cStatus options:0 context:NULL];
		
		NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *finalPath;
		
		finalPath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", cProjects]];
		self.projects= [NSMutableDictionary dictionaryWithContentsOfFile:finalPath];
		if (!self.projects) self.projects= [NSMutableDictionary dictionary];
		
		finalPath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", cTrackingIntervals]];
		self.trackingIntervals= [NSMutableArray arrayWithContentsOfFile:finalPath];
		if (!self.trackingIntervals) self.trackingIntervals= [NSMutableArray array];
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
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *finalPath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", keyPath]];
	
	// Save whaterver object just changed
	if (![[self valueForKey:keyPath] writeToFile:finalPath atomically:YES]) {
		NSLog(@"Writting to '%@' failed!", finalPath);
	}
}

#pragma mark Delete data

- (void)deleteTrackingIntervals:(BOOL)all {
	NSMutableArray *toKeep= [NSMutableArray array];
	
	if (!all) {
		// Just what's older than a week
		NSDate * date= [NSDate dateWithTimeIntervalSinceNow:-604800];
		
		for (NSMutableDictionary *trackingInterval in self.trackingIntervals) {
			if ([date compare:[trackingInterval objectForKey:cStartTime]] == NSOrderedAscending) {
				[toKeep addObject:trackingInterval];
			} else {
				break;
			}
		}
	}
	
	// Don't delete the one that's still being tracked
	if ([self.active boolValue]) {
		[toKeep addObject:[self.trackingIntervals objectAtIndex:0]];
	}
	
	self.trackingIntervals= toKeep;
	
	// Notify
	[self didChangeCollection:cTrackingIntervals];
}

#pragma mark Getter

- (NSTimeInterval)timeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval {	
	if (pInterval == nil) return 0;
	
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
