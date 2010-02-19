//
//  WTStatisticsViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTActivities;

@interface WTOverviewRootController : UIViewController <UINavigationControllerDelegate>{
	UINavigationController *navController;
	WTActivities *tableController;
}

- (void)pushDetailViewWithInterval:(NSMutableDictionary *)activities;

@end
