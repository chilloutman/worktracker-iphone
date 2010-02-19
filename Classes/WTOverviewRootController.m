//
//  WTStatisticsViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTOverviewRootController.h"

#import "WTActivities.h"
#import "WTTrackingDetails.h"

@implementation WTOverviewRootController

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		self.tabBarItem= [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Overview", @"Previous trackings") image:[UIImage imageNamed:@"eye.png"] tag:2];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	self.view= [[UIView alloc] initWithFrame:screen];
	[self.view release];
	
	// NavigationController
	
	tableController= [[WTActivities alloc] init];
	tableController.superController= self;
	
	navController= [[UINavigationController alloc] initWithRootViewController:tableController];
	[tableController release];
	navController.delegate= self;
	
	[self.view addSubview:navController.view];
}

- (void)viewWillAppear:(BOOL)animated {
	// Notify the currently visible view
	[tableController.tableView reloadData];
	[tableController viewWillAppear:animated];
}

#pragma mark push & pop

- (void)pushDetailViewWithInterval:(NSMutableDictionary *)activities {
	WTTrackingDetails *detailViewController= [[WTTrackingDetails alloc] initWithActivity:activities];
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
