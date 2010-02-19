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
@synthesize activities;

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
		
		finalPath= [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", cActivities]];
		self.activities= [NSMutableArray arrayWithContentsOfFile:finalPath];
		if (!self.activities) self.activities= [NSMutableArray array];
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

- (void)deleteAllActivities:(BOOL)all {
	NSMutableArray *toKeep= [NSMutableArray array];
	
	if (!all) {
		// Just what's older than a week
		NSDate * date= [NSDate dateWithTimeIntervalSinceNow:-604800];
		
		for (NSMutableDictionary *activity in self.activities) {
			if ([date compare:[activity objectForKey:cStartTime]] == NSOrderedAscending) {
				[toKeep addObject:activity];
			} else {
				break;
			}
		}
	}
	
	// Don't delete the one that's still being tracked
	if ([self.active boolValue]) {
		[toKeep addObject:[self.activities objectAtIndex:0]];
	}
	
	self.activities= toKeep;
	
	// Notify
	[self didChangeCollection:cActivities];
}

#pragma mark Custom getter

- (NSTimeInterval)timeIntervalForActivity:(NSMutableDictionary *)pInterval {	
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
