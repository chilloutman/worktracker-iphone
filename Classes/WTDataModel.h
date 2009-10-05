//
//  WTDataModel.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Manages and saves data
@interface WTDataModel : NSObject {
	NSNumber *active; // This is an object and not a BOOL because of some advantages with KVO and NSUserDefaults. However, it could be an NSNumber...
	NSMutableDictionary *projects;
	NSMutableArray *trackingIntervals; // Contains all trackingIntervals. sorted by startDate (0 == newest). See WTConstants.h for more info.
}

@property (retain) NSNumber *active;
@property (retain) NSMutableDictionary *projects;
@property (retain) NSMutableArray *trackingIntervals;

// Getter for the singleton instance
+ (WTDataModel *)sharedDataModel;

// Every time a collection was changed the model has to be informed so it can save the data
- (void)didChangeCollection:(NSString *)keyPath;
- (void)deleteTrackingIntervals:(BOOL)all;

// Getters for specific data
- (NSTimeInterval)timeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval;
- (NSArray *)trackingIntervalsForProject:(NSString *)project;

@end
