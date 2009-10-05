//
//  WTProjectsRootController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjectsRootController.h"
#import "WTProjects.h"
#import "WTProjectDetails.h"

#import "WTConstants.h"

@implementation WTProjectsRootController

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		self.tabBarItem= [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Projects", @"") image:[UIImage imageNamed:@"cabinet.png"] tag:1];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	screen.size.height+= 20;
	self.view= [[[UIView alloc] initWithFrame:screen] autorelease];
	
	tableController= [[[WTProjects alloc] init] autorelease];
	tableController.superController= self;
	
	navController= [[UINavigationController alloc] initWithRootViewController:tableController];
	navController.delegate= self;
	[self.view addSubview:navController.view];
}

- (void)viewWillDisappear:(BOOL)animated {
	// tableController cares about this
	[tableController viewWillDisappear:animated];
}

#pragma mark UINavigationController

- (void)pushDetailViewWithProject:(NSMutableDictionary *)project name:(NSString *)projectName {
	WTProjectDetails *detailViewController= [[WTProjectDetails alloc] initWithProject:project projectName:projectName];
	[navController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

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
