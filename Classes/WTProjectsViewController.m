//
//  WTProjectsViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjectsViewController.h"
#import "WTProjectAdd.h"
#import "WTTableBackgorund.h"

#import "WTDataModel.h"

#import "WTConstants.h"

@implementation WTProjectsViewController

@synthesize model;

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		self.tabBarItem= [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Projects", @"") image:[UIImage imageNamed:@"cabinet.png"] tag:1];
		self.model= [WTDataModel sharedDataModel];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	screen.size.height+= 20;
	self.view= [[[UIView alloc] initWithFrame:screen] autorelease];
	
	// TableView
	tableView= [[UITableView alloc] initWithFrame:screen];
	tableView.delegate= self;
	tableView.dataSource= self;
	tableView.delaysContentTouches= NO;
	
	// Create a custom view with a gray background and a shadow for the top
	tableView.tableHeaderView= [[[WTTableBackgorund alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height / 2)] autorelease];
	// Have the tableview ignore the headerView when computing size
	tableView.contentInset = UIEdgeInsetsMake(-(tableView.tableHeaderView.frame.size.height), 0, 0, 0);
	
	// Container
	tableController= [[[UITableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
	tableController.tableView= tableView;
	tableController.title= self.tabBarItem.title;
	tableController.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProject)];
	editButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView)];
	doneButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editTableView)];
	tableController.navigationItem.leftBarButtonItem= editButton;
	
	navController= [[UINavigationController alloc] initWithRootViewController:tableController];
	[self.view addSubview:navController.view];
}

#pragma mark Buttons / Manage content

// Add button was pressed
-(void)addNewProject {
	if (!projectAddView) {
		projectAddView= [[WTProjectAdd alloc] init];
		projectAddView.superController= self;
	}
	[self presentModalViewController:projectAddView animated:YES];
}

// User entered a name and pressed the done button 
- (void)shouldAddNewProjectWithName:(NSString *)projectName {
	if ([self.model.projects containsObject:projectName]) return;
	
	// Add new project
	[self.model.projects insertObject:projectName atIndex:0];
	// Notify the model so it can save the data
	[self.model didChangeCollection:cProjects];
	
	[tableView reloadData];
}

// User tabbed the edit Button
- (void)editTableView {
	if (tableView.editing) {
		tableController.navigationItem.leftBarButtonItem= editButton;
		[tableView setEditing:NO animated:YES];
	} else {
		tableController.navigationItem.leftBarButtonItem= doneButton;
		[tableView setEditing:YES animated:YES];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	// Disable editing on disappear
	if (tableView.editing) {
		[self editTableView];
	}
}

#pragma mark UITableView dataSource / delegate

// Building
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.model.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier= @"MyIdendifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
		cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	}
	
	cell.showsReorderControl= YES;
	cell.textLabel.text= [self.model.projects objectAtIndex:indexPath.row];
	
	return cell;
}

// Editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	 return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)pTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Remove Data from model
		[self.model.projects removeObjectAtIndex:indexPath.row];
		[self.model didChangeCollection:cProjects];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

// Reorder rows
- (BOOL)tableView:(UITableView *)tV canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tV moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	// Move the Object inside the Model
	NSMutableDictionary *sourceObject= [[self.model.projects objectAtIndex:sourceIndexPath.row] retain];
	[self.model.projects removeObjectAtIndex:sourceIndexPath.row];
	[self.model.projects insertObject:sourceObject atIndex:destinationIndexPath.row];
	[sourceObject release];
	
	[self.model didChangeCollection:cProjects];
}

// Selection

- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

- (void)dealloc {
	[tableView release];
	[navController release];
	[doneButton release];
	[editButton release];
	
	[self.model release];
    [super dealloc];
}


@end
