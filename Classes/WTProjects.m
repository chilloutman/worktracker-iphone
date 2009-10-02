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

#import "WTDataModel.h"

#import "WTConstants.h"

@implementation WTProjects

@synthesize superController;

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
}

- (void)viewWillAppear:(BOOL)animated {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
	if (!projectAddView) {
		projectAddView= [[WTProjectAdd alloc] init];
		projectAddView.superController= self;
	}
	[self presentModalViewController:projectAddView animated:YES];
}

// User entered a name and pressed the done button 
- (void)shouldAddNewProjectWithName:(NSString *)projectName color:(UIColor *)projectColor {
	//if ([model.projects containsObject:projectName]) return;
	
	NSMutableDictionary *project= [NSMutableDictionary dictionaryWithCapacity:cProjectDictSize];
	[project setObject:projectName forKey:cProjectName];
	[project setObject:[NSKeyedArchiver archivedDataWithRootObject:projectColor] forKey:cProjectColor];
	
	// Add new project
	[model.projects insertObject:project atIndex:0];
	// Notify the model so it can save the data
	[model didChangeCollection:cProjects];
	
	[tableView reloadData];
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
	NSMutableDictionary *project= [model.projects objectAtIndex:indexPath.row];
	
	UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil
												   message:[NSString stringWithFormat:NSLocalizedString(@"Also delete all tracking intervals related to %@?", @""), [project objectForKey:cProjectName]]
												  delegate:self 
										 cancelButtonTitle:@"no" otherButtonTitles:@"No, just delete the project", @"delete everything", nil];
	[alert show];
	
	// Remove Data from model
	[model.projects removeObjectAtIndex:indexPath.row];
	[model didChangeCollection:cProjects];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView release];
	switch (buttonIndex) {
		case 0:
			// Cancel
			break;
		case 1:
			// Only delete the project
			break;
		case 2:
			// Delete the project and everyting related
			break;
			
	}
}

#pragma mark UITableView build

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [model.projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier= @"MyIdendifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
		cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
	}
	
	cell.showsReorderControl= YES;
	cell.textLabel.text= [[model.projects objectAtIndex:indexPath.row] objectForKey:cProjectName];
	
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

// Reorder rows
- (BOOL)tableView:(UITableView *)tV canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tV moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	// Move the Object inside the Model
	NSMutableDictionary *sourceObject= [[model.projects objectAtIndex:sourceIndexPath.row] retain];
	[model.projects removeObjectAtIndex:sourceIndexPath.row];
	[model.projects insertObject:sourceObject atIndex:destinationIndexPath.row];
	[sourceObject release];
	
	[model didChangeCollection:cProjects];
}
	
// Selection
- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *project= [model.projects objectAtIndex:indexPath.row];
	[self.superController pushDetailViewWithProject:project];
}

#pragma mark -

- (void)dealloc {
	[tableView release];
	[doneButton release];
	[editButton release];
	[model release];
	
    [super dealloc];
}


@end
