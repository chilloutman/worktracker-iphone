//
//  WTProjectsViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTDataModel, WTProjectAdd;

@interface WTProjectsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	WTDataModel *model;
	
	UINavigationController *navController;
	UITableViewController *tableController;
	UIBarButtonItem *editButton;
	UIBarButtonItem *doneButton;
	UITableView *tableView;
	
	WTProjectAdd *projectAddView;
}

@property (nonatomic, retain) WTDataModel *model;

- (void)shouldAddNewProjectWithName:(NSString *)projectName;

@end
