//
//  WorkTrackerAppDelegate.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "WorkTrackerAppDelegate.h"
#import "WTMainViewController.h"
#import "WTProjectsRootController.h"
#import "WTOverviewRootController.h"

#import "WTDataModel.h"
#import "WTEngine.h"
#import "WTSort.h"

@implementation WorkTrackerAppDelegate

@synthesize window, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// UI
	
	//[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Initialize viewControllers
	WTMainViewController *mainController= [[[WTMainViewController alloc] init] autorelease]; // Tab 1
	WTProjectsRootController *projectsController= [[[WTProjectsRootController alloc] init] autorelease]; // Tab 2
	WTOverviewRootController *historyController= [[[WTOverviewRootController alloc] init] autorelease]; // Tab 3
	NSArray *viewControllers= [NSArray arrayWithObjects:mainController, projectsController, historyController, nil];
	
	
	// Setup tabBarcontroller
	self.tabBarController= [[UITabBarController alloc] init];
	[self.tabBarController setViewControllers:viewControllers animated:YES];
	
	
	[window addSubview:self.tabBarController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[window release];
    [tabBarController release];
    [super dealloc];
}


@end
