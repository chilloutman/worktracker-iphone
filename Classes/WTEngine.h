//
//  WTEngine.h
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  ***
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

- (BOOL)isRunning;
- (NSString *)formattedStatus;

- (void)startTrackingProject:(NSString *)projectName withComment:(NSString *)comment;
- (void)stopTracking;

- (void)pingEvery:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector identifier:(NSString *)key;
- (void)stopPinging:(NSString *)key;

@end
