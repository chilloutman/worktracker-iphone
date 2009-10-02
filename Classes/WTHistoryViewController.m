//
//  WTStatisticsViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTHistoryViewController.h"

#import "WTTrackingIntervals.h"
#import "WTTrackingDetails.h"

@implementation WTHistoryViewController

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		self.tabBarItem= [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"History", @"Previous trackings") image:[UIImage imageNamed:@"backwards.png"] tag:2];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	self.view= [[UIView alloc] initWithFrame:screen];
	[self.view release];
	
	// NavigationController
	
	WTTrackingIntervals *tableController= [[WTTrackingIntervals alloc] init];
	tableController.superController= self;
	
	navController= [[UINavigationController alloc] initWithRootViewController:tableController];
	[tableController release];
	navController.delegate= self;
	
	[self.view addSubview:navController.view];
}

#pragma mark push & pop

- (void)pushDetailViewWithInterval:(NSMutableDictionary *)trackingInterval {
	WTTrackingDetails *detailViewController= [[WTTrackingDetails alloc] initWithTrackingInterval:trackingInterval];
	[navController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navC willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// Somehow viewWillAppear is not getting called so I'm doing it manually...
	[viewController viewWillAppear:animated];
}

#pragma mark -

- (void)dealloc {
	[navController release];
    [super dealloc];
}


@end
