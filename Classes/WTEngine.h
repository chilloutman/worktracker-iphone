//
//  WTEngine.h
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTDataModel;

// Controls status
@interface WTEngine : NSObject {
	WTDataModel *model;
	NSMutableDictionary *timers;
}

+ (WTEngine *)sharedEngine;

- (BOOL)running;

- (void)startTrackingProjectAtIndex:(NSInteger)index;
- (void)stopTracking;

- (void)pingEvery:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector identifier:(NSString *)key;
- (void)stopPinging:(NSString *)key;

@end
