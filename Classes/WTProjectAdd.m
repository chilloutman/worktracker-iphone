//
//  WTProjectAddViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 09.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjectAdd.h"
#import "WTProjects.h"

#import "WTConstants.h"
#import "WTUtil.h"

@implementation WTProjectAdd

@synthesize superController;

#pragma mark Build

- (id)init {
	if (self= [super init]) {
		colors= [[NSArray alloc] initWithObjects:[UIColor whiteColor], [UIColor grayColor], [UIColor blueColor], [UIColor redColor], [UIColor greenColor], nil];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	CGSize contentSize= CGSizeMake(screen.size.width, screen.size.height/2 - 28);
	
	self.view= [[UIView alloc] initWithFrame:CGRectMake(0.0, -250.0, contentSize.width, contentSize.height)];
	
	tableView= [[UITableView alloc] initWithFrame:CGRectMake(screen.origin.x, screen.origin.y + 23, contentSize.width, contentSize.height) style:UITableViewStyleGrouped];
	tableView.dataSource= self;
	tableView.delegate= self;
	
	// Toolbar
	
	UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	doneButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStyleDone target:self action:@selector(done)];
	doneButton.enabled= NO;
	UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *titleItem= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New Project", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
	
	UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 45)];
	[toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, titleItem, flexSpace, doneButton, nil]];
	[self.view addSubview:toolbar];
	
	[toolbar release];
	[cancelButton release];
	[titleItem release];
	[flexSpace release];
	
	// Hardcoding action... :-)
	CGRect cellContentFrame= CGRectMake(10, 7, 280, 31); // This is the right size to fit a textView inside a UITableViewCell
	
	// This is where the user types a name for the new project
	nameField= [[UITextField alloc] initWithFrame:cellContentFrame];
	nameField.placeholder= NSLocalizedString(@"Project Name", @"Placeholder for project name text field");
	nameField.adjustsFontSizeToFitWidth= YES;
	nameField.font= [UIFont systemFontOfSize:20];
	nameField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
	nameField.autocorrectionType= UITextAutocorrectionTypeNo;
	nameField.autocapitalizationType= UITextAutocapitalizationTypeNone;
	nameField.returnKeyType= UIReturnKeyNext;
	nameField.clearButtonMode= UITextFieldViewModeWhileEditing;
	nameField.delegate= self;
	
	// Client
	clientField= [[UITextField alloc] initWithFrame:cellContentFrame];
	clientField.placeholder= NSLocalizedString(@"Client", @"Placeholder for client text field");
	clientField.adjustsFontSizeToFitWidth= YES;
	clientField.font= [UIFont systemFontOfSize:20];
	clientField.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
	clientField.autocorrectionType= UITextAutocorrectionTypeNo;
	clientField.autocapitalizationType= UITextAutocapitalizationTypeNone;
	clientField.returnKeyType= UIReturnKeyNext;
	clientField.clearButtonMode= UITextFieldViewModeWhileEditing;
	clientField.delegate= self;
	
	// Color picker
	NSMutableArray *colorImages= [NSMutableArray arrayWithCapacity:[colors count]];
	for (UIColor *color in colors) {
		[colorImages addObject:[WTUtil imageWithColor:color]];
	}
	
	colorPicker= [[UISegmentedControl alloc] initWithItems:colorImages];
	[colorPicker addTarget:self action:@selector(didSelectColor) forControlEvents:UIControlEventValueChanged];
	
	[self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	nameField.text= nil;
	clientField.text= nil;
	//[nameField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
	[nameField becomeFirstResponder];
	colorPicker.selectedSegmentIndex= 0;
}

- (void)viewWillDisappear:(BOOL)animated {
	[nameField resignFirstResponder];
	[clientField resignFirstResponder];
	colorPicker.selectedSegmentIndex= 0;
}

- (void)dismissView {
	[self viewWillDisappear:YES];
	[self.superController viewWillAppear:YES];
	
	[UIView beginAnimations:nil context:nil];
	CGRect r= self.view.frame;
	r.origin.y= -250;
	self.view.frame= r;
	[UIView commitAnimations];
}

#pragma mark Buttons & segmentedControl

- (void)updateDoneButton {
	doneButton.enabled= !([nameField.text isEqualToString:@""] || nameField.text == nil);
}

- (void)done {
	[self.superController shouldAddNewProjectWithName:nameField.text color:projectColor client:clientField.text];
	
	[self dismissView];
}

- (void)cancel {
	// Do nothing...
	[self dismissView];
}

- (void)didSelectColor {
	projectColor= [colors objectAtIndex:colorPicker.selectedSegmentIndex];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == clientField) {
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		[nameField becomeFirstResponder];
	} else {
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
		[clientField becomeFirstResponder];
	}

	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[self performSelector:@selector(updateDoneButton) withObject:nil afterDelay:0.0];
	
	return YES;
}

#pragma mark UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)pTableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return nil;//return NSLocalizedString(@"Project Name", @"Title for the textField where the project name is supposed to be entered");
		case 1: return NSLocalizedString(@"Color", @"Title for the place where the user can select a color for the project");
	} 
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
		case 1:
			return 1;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"cellID";
	
	UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
		cell.selectionStyle= UITableViewCellSelectionStyleNone;
	}
	
	CGRect c;
	
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0) [cell.contentView addSubview:nameField];
			else [cell.contentView addSubview:clientField];
			break;
		case 1:
			c= cell.contentView.frame;
			c.size.width-= 20;
			colorPicker.frame= c;
			[cell.contentView addSubview:colorPicker];
			break;
	}
	
	return cell;
}

#pragma mark -

- (void)dealloc {
	[nameField release];
	[clientField release];
	[doneButton release];
	[colors release];
	[self.superController release];
    [super dealloc];
}

@end
