//
//  WTStartTrackingRootController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTStartTrackingRootController.h"
#import "WTProjectPicker.h"

@implementation WTStartTrackingRootController

@synthesize superController;

- (id)init {
	if (self= [super init]) {
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	screen.size.height+= 20;
	self.view= [[UIView alloc] initWithFrame:screen];
	[self.view release];
	
	tableController= [[WTProjectPicker alloc] init];
	tableController.superController= self.superController;
	
	navController= [[UINavigationController alloc] initWithRootViewController:tableController];
	navController.delegate= self;
	[self.view addSubview:navController.view];
	
	[tableController release];
}

- (void)viewWillAppear:(BOOL)animated {
	[tableController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	// tableController cares about this
	[tableController viewWillDisappear:animated];
}

#pragma mark UINavigationController

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
