//
//  WTStatisticsViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTTrackingIntervals;

@interface WTOverviewRootController : UIViewController <UINavigationControllerDelegate>{
	UINavigationController *navController;
	WTTrackingIntervals *tableController;
}

- (void)pushDetailViewWithInterval:(NSMutableDictionary *)trackingInterval;

@end
