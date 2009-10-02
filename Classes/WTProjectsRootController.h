//
//  WTProjectsRootController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTProjects;

@interface WTProjectsRootController : UIViewController <UINavigationControllerDelegate> {
	UINavigationController *navController;
	
	WTProjects *tableController;
}

- (void)pushDetailViewWithProject:(NSMutableDictionary *)project;

@end
