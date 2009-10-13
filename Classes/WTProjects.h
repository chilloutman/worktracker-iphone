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
	
	NSArray *intervalsToRemove;
	NSUInteger indexToDelete;
	
	WTProjectAdd *projectAddView;
	WTProjectsRootController *superController;
	
	WTDataModel *model;
	NSArray *projects;
}

@property (nonatomic, retain) WTProjectsRootController *superController;
@property (nonatomic, retain) NSArray *projects;

- (void)shouldAddNewProjectWithName:(NSString *)projectName color:(UIColor *)projectColor client:(NSString *)client;
- (void)shouldDeleteProjectAtIndexPath:(NSIndexPath *)indexPath;

// Private
- (void)refreshProjects;
- (void)editTableView;
- (void)deleteProjectAtIndex:(NSUInteger)indexPath;

@end
