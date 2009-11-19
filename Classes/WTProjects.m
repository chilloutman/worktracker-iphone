//
//  WTProjects.m
//  WorkTracker
//
//  Created by Lucas Neiva on 02.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjects.h"
#import "WTProjectsRootController.h"
#import "WTProjectAdd.h"
#import "WTProjectDetails.h"

#import "WTProjectCell.h"

#import "WTDataModel.h"
#import "WTConstants.h"
#import "WTSort.h"
#import "WTUtil.h"

@implementation WTProjects

@synthesize superController;
@synthesize projects;

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
		self.title= NSLocalizedString(@"Projects", @"");
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	screen.size.height+= 20;
	
	// NavigationBar
	self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProject)];
	editButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTableView)];
	doneButton= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editTableView)];
	self.navigationItem.leftBarButtonItem= editButton;
	
	// TableView
	tableView= [[UITableView alloc] initWithFrame:screen style:UITableViewStylePlain];
	tableView.delegate= self;
	tableView.dataSource= self;
	
	self.view= tableView;
	
	// Prepare modal projectAdd view
	
	if (!projectAddView) {
		projectAddView= [[WTProjectAdd alloc] init];
		projectAddView.superController= self;
	}
	
	// The view is added offscreen
	[self.superController.view addSubview:projectAddView.view];
}

- (void)viewWillAppear:(BOOL)animated {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
	[self refreshProjects];
}

- (void)refreshProjects {
	self.projects= [[model.projects allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void)viewWillDisappear:(BOOL)animated {
	// Disable editing on disappear
	if (tableView.editing) {
		[self editTableView];
	}
}

#pragma mark Buttons / Manage content

// Add button was pressed
-(void)addNewProject {	
	// And flies in
	[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
	CGRect r=projectAddView.view.frame;
	r.origin.y= 0;
	projectAddView.view.frame= r;
	projectAddView.view.bounds= r;
	[projectAddView viewWillAppear:YES];
	[UIView commitAnimations];
	
	//[self presentModalViewController:projectAddView animated:YES];
}

// User entered a name and pressed the done button 
- (void)shouldAddNewProjectWithName:(NSString *)projectName color:(UIColor *)projectColor client:(NSString *)client {
	// Are there intervals with this project name
	NSArray *intervals=[model.trackingIntervals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(project == %@)", projectName]];
	
	NSMutableDictionary *project= [NSMutableDictionary dictionaryWithCapacity:cProjectDictSize];
	if (client)[project setObject:client forKey:cProjectClient];
	[project setObject:[NSNumber numberWithInt:[intervals count]] forKey:cProjectNumber];
	[project setObject:[NSNumber numberWithDouble:[WTUtil totalTimeForIntervals:intervals]] forKey:cProjectTime];
	[project setObject:[NSKeyedArchiver archivedDataWithRootObject:projectColor] forKey:cProjectColor];
	
	// Add new project
	[model.projects setObject:project forKey:projectName]; // The project name is used as key
	// Notify the model so it can save the data
	[model didChangeCollection:cProjects];
	// Refresh projects array
	[self refreshProjects];
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[projects indexOfObject:project] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

// User tabbed the edit Button
- (void)editTableView {
	if (tableView.editing) {
		self.navigationItem.leftBarButtonItem= editButton;
		[tableView setEditing:NO animated:YES];
	} else {
		self.navigationItem.leftBarButtonItem= doneButton;
		[tableView setEditing:YES animated:YES];
	}
}

- (void)shouldDeleteProjectAtIndexPath:(NSIndexPath *)indexPath {
	NSString *projectToDelete= [projects objectAtIndex:indexPath.row];
	
	// Are there tracking intervals that are bound to this project?
	intervalsToRemove= [[model.trackingIntervals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(project == %@)", projectToDelete]] retain];
	indexToDelete= indexPath.row;
	
	if ([intervalsToRemove count] > 0) {
		// Ask if the intervals should also be deleted
		UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil
													   message:[NSString stringWithFormat:NSLocalizedString(@"Also delete all tracking intervals related to %@?", @""), projectToDelete]
													  delegate:self 
											 cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											 otherButtonTitles:NSLocalizedString(@"Just delete the project", @""), NSLocalizedString(@"Delete everything", @""), nil];
		[alert show];
	} else {
		// Remove the project
		[self deleteProjectAtIndex:indexToDelete];
		[intervalsToRemove release];
	}
}

- (void)deleteProjectAtIndex:(NSUInteger)index {
	NSString *projectToDelete= [projects objectAtIndex:index];
	[model.projects removeObjectForKey:projectToDelete];
	
	[model didChangeCollection:cProjects];
	[self refreshProjects];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView release];
	if (buttonIndex == 0) {
		[tableView setEditing:NO animated:YES];
		return;
	}
	
	// Remove the project
	[self deleteProjectAtIndex:indexToDelete];
	
	if (buttonIndex == 2) {
		// Also remove all related tracking intervals
		[model.trackingIntervals removeObjectsInArray:intervalsToRemove];
		[intervalsToRemove release];
		
		// Notify others
		[model didChangeCollection:cTrackingIntervals];
		[[WTSort sharedSortingModel] invalidateSectionsForSortingType:WTSortingAll];
	}
}

#pragma mark UITableView build

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"ABCell";
	
	WTProjectCell *cell= (WTProjectCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[WTProjectCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	
	NSString *projectName= [projects objectAtIndex:indexPath.row];
	NSMutableDictionary *project= [model.projects objectForKey:projectName];
	
	cell.firstText= projectName;
	cell.lastText= [project objectForKey:cProjectClient];
	cell.color= [NSKeyedUnarchiver unarchiveObjectWithData:[project objectForKey:cProjectColor]];
		 
	return cell;
}

#pragma mark UITableView editing & selection

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)pTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self shouldDeleteProjectAtIndexPath:(NSIndexPath *)indexPath];
	}
}

// Reorder rows?
	
// Selection
- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *projectName= [projects objectAtIndex:indexPath.row];
	NSMutableDictionary *project= [model.projects objectForKey:projectName];
	NSArray *trackingIntervals= [model.trackingIntervals filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"project == %@", projectName]];
	
	// Display detail view
	WTProjectDetails *detailViewController= [[WTProjectDetails alloc] initWithProject:project name:projectName trackingIntervals:trackingIntervals];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}

#pragma mark -

- (void)dealloc {
	[tableView release];
	[doneButton release];
	[editButton release];
	[projects release];
	
    [super dealloc];
}


@end
