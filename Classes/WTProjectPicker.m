//
//  WTProjectPicker.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjectPicker.h"
#import	"WTMainViewController.h"
#import "WTCommentView.h"
#import "WTDataModel.h"

#import "WTConstants.h"

@implementation WTProjectPicker

@synthesize picker;
@synthesize superController;
@synthesize commentView;

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		self.title= NSLocalizedString(@"Start Tracking", @"Title for projectPicker");
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	self.view= [[[UIView alloc] initWithFrame:screen] autorelease];
	self.view.backgroundColor= [UIColor groupTableViewBackgroundColor];

	// Navigation Bar
	UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(userCanceled)];
	UIBarButtonItem *okButton= [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(projectWasSelected)];
	
	self.navigationItem.rightBarButtonItem= okButton;
	[okButton release];
	self.navigationItem.leftBarButtonItem= cancelButton;
	[cancelButton release];
	
	// Label
	UILabel *projectLabel= [[UILabel alloc] initWithFrame:CGRectMake(15.0, 10.0, screen.size.width-30.0, 40.0)];
	projectLabel.font= [UIFont boldSystemFontOfSize:18];
	projectLabel.textColor= [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	projectLabel.backgroundColor= [UIColor clearColor];
	projectLabel.text= NSLocalizedString(@"Pick a project", @"Ask user to select a project");
	[self.view addSubview:projectLabel];
	[projectLabel release];
	 
	// Project selection
	self.picker= [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 60.0, screen.size.width, 0.0)];
	picker.delegate= self;
	picker.dataSource= self;
	picker.showsSelectionIndicator= YES;
	[self.view addSubview:self.picker];
	
	// TableView
	
	tableView= [[UITableView alloc] initWithFrame:CGRectMake(0.0, projectLabel.frame.size.height + picker.frame.size.height + 20.0, screen.size.width, 200.0) style:UITableViewStyleGrouped];
	tableView.contentInset= UIEdgeInsetsMake(35.0, 0.0, 0.0, 0.0);
	tableView.dataSource= self;
	tableView.delegate= self;
	[self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
	[picker reloadComponent:0];
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	[super viewWillAppear:animated];
}

#pragma mark Buttons

- (void)projectWasSelected {
	NSString *comment= [commentView.commentField.text retain];
	self.commentView= nil;
	// Nofify the mainView that a proj. was selectet
	[superController userPickedProjectAtIndex:[picker selectedRowInComponent:0] comment:(NSString *)comment];
	[comment release];
}

- (void)userCanceled {
	self.commentView= nil;
	[superController userCanceledProjectPicker];
}

#pragma mark UIPickerView

// With the picker the user can select wich project should be tracked 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)c {
	return [[WTDataModel sharedDataModel].projects count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)c {
	return [[[WTDataModel sharedDataModel].projects allKeys] objectAtIndex:row];
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)pTableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tV numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:	return 1;
		default: return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"cellID";
	
	UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
		cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
	}
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text= NSLocalizedString(@"Comment", @"");
			NSString *comment= [commentView.commentField.text copy];
			if ([comment length] > 12) cell.detailTextLabel.text= [[comment substringToIndex:11] stringByAppendingString:@"..."];
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.commentView) {
		commentView= [[WTCommentView alloc] init];
	}
	
	[self.navigationController pushViewController:commentView animated:YES];
}

#pragma mark -

- (void)dealloc {
	[self.commentView release];
	[self.picker release];
	[self.superController release];
	[tableView release];
	[super dealloc];
}

@end
