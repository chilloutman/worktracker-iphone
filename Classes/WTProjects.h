//
//  WTProjects.h
//  WorkTracker
//
//  Created by Lucas Neiva on 02.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTProjectsRootController, WTProjectAdd, WTDataModel;

@interface WTProjects : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	UITableView *tableView;
	UIBarButtonItem *editButton;
	UIBarButtonItem *doneButton;
	
	WTProjectAdd *projectAddView;
	WTProjectsRootController *superController;
	
	WTDataModel *model;
}

@property (nonatomic, retain) WTProjectsRootController *superController;

- (void)shouldAddNewProjectWithName:(NSString *)projectName;

// Private
- (void)editTableView;

@end
