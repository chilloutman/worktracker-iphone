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
	NSString *status; // This is an object and not a BOOL because of some advantages with KVO and NSUserDefaults. However, it could be an NSNumber...
	NSMutableArray *projects; // Could be expanded as dictionary for more statistics.
	NSMutableArray *trackingIntervals; // Contains all trackingIntervals. sorted by startDate (0 == newest). See WTConstants.h for more info.
}

@property (copy) NSString *status;
@property (retain) NSMutableArray *projects;
@property (retain) NSMutableArray *trackingIntervals;

// Getter for the singleton instance
+ (WTDataModel *)sharedDataModel;

// Every time a collection was changed the model has to be informed so it can save the data
- (void)didChangeCollection:(NSString *)keyPath;
- (void)deleteTrackingIntervals:(BOOL)all;

- (NSTimeInterval)timeIntervalForTrackingInterval: (NSMutableDictionary *)pInterval;

// Strings for the UI
- (NSString *)formattedTotalTimeForDay:(NSInteger)dayID withActive:(BOOL)active;
- (NSString *)formattedStatus;
- (NSString *)formattedStartTimeForTrackingInterval:(NSMutableDictionary *)pInterval;
- (NSString *)formattedStopTimeForTrackingInterval:(NSMutableDictionary *)pInterval;
- (NSString	*)formattedTimeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval decimal:(BOOL)decimal;
- (NSString *)formattedProjectNameForTrackingInterval:(NSMutableDictionary *)pInterval;

@end
