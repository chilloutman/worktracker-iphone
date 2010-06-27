//
//  WTDataModel.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import "WTDataModel.h"
#import "WTUtil.h"

#import "WTConstants.h"

static WTDataModel *sharedInstace= nil;

@interface WTDataModel()
- (void)loadSavedData;
- (NSString *)documentPathForFilename:(NSString *)file;
- (void)loadStatusFromUserDefaults;
@end

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
		[self loadSavedData];
		[self addObserver:self forKeyPath:cStatus options:0 context:NULL];
	}
	
	return self;
}

- (void)loadSavedData {
	[self loadStatusFromUserDefaults];
	
	NSString *path= nil;
	
	path= [self documentPathForFilename:[NSString stringWithFormat:@"%@.plist", cProjects]];
	self.projects= [NSMutableDictionary dictionaryWithContentsOfFile:path];
	if (!self.projects)
		self.projects= [NSMutableDictionary dictionary];
	
	path= [self documentPathForFilename:[NSString stringWithFormat:@"%@.plist", cActivities]];
	self.activities= [NSMutableArray arrayWithContentsOfFile:path];
	if (!self.activities)
		self.activities= [NSMutableArray array];
}

- (void)loadStatusFromUserDefaults {
	NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
	
	self.active= [userDefaults objectForKey:cStatus];
	if (!self.active) {
		self.active= [NSNumber numberWithBool:NO];
	}
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
	} else {
		return 0.0;
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

#pragma mark KVO / Saving data

// KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)c {
	NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
	
	// Save whaterver object just changed
	[userDefaults setObject:[object valueForKey:keyPath] forKey:keyPath];
}

// Manual implementation of KVO because Apple's KVO fails when using collections
- (void)didChangeCollection:(NSString *)keyPath {
	NSString *path= [self documentPathForFilename:[NSString stringWithFormat:@"%@.plist", keyPath]];
	
	// Save whaterver object just changed
	if (![[self valueForKey:keyPath] writeToFile:path atomically:YES]) {
		NSLog(@"Writting to '%@' failed!", path);
	}
}

#pragma mark Helper

- (NSString *)documentPathForFilename:(NSString *)file {
	NSString *documentDir= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [documentDir stringByAppendingPathComponent:file];
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
