//
//  WTEngine.h
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTDataModel, WTSort;

// Controls status
@interface WTEngine : NSObject {
	WTDataModel *model;
	WTSort *sortModel;
	NSMutableDictionary *timers;
}

+ (WTEngine *)sharedEngine;

- (BOOL)running;
- (NSString *)formattedStatus;

- (void)startTrackingProject:(NSString *)projectName;
- (void)stopTracking;

- (void)pingEvery:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector identifier:(NSString *)key;
- (void)stopPinging:(NSString *)key;

@end
