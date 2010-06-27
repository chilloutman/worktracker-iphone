//
//  WTProjects.h
//  WorkTracker
//
//  Created by Lucas Neiva on 02.10.09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
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

@end
