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

@interface WorkTrackerAppDelegate()
- (void)initUI;
@end

@implementation WorkTrackerAppDelegate

@synthesize window, tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	[self initUI];
	
	[self.window addSubview:self.tabBarController.view];
	[self.window makeKeyAndVisible];
}

- (void)initUI {
	WTMainViewController *mainController= [[WTMainViewController alloc] init]; // Tab 1
	WTProjectsRootController *projectsController= [[WTProjectsRootController alloc] init]; // Tab 2
	WTOverviewRootController *historyController= [[WTOverviewRootController alloc] init]; // Tab 3
	
	NSArray *viewControllers= [NSArray arrayWithObjects:mainController, projectsController, historyController, nil];
	[viewControllers makeObjectsPerformSelector:@selector(release)];	
	
	self.tabBarController= [[UITabBarController alloc] init];
	[self.tabBarController setViewControllers:viewControllers animated:YES];
}

- (void)dealloc {
	[window release];
    [tabBarController release];
    [super dealloc];
}


@end
