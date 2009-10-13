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
	
	self.view= [[UIView alloc] initWithFrame:screen];
	
	tableView= [[UITableView alloc] initWithFrame:CGRectMake(screen.origin.x, screen.origin.y + 23, screen.size.width, screen.size.height/2 - 28) style:UITableViewStyleGrouped];
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

#pragma mark Buttons & segmentedControl

- (void)updateDoneButton {
	doneButton.enabled= !([nameField.text isEqualToString:@""] || nameField.text == nil);
}

- (void)done {
	[self.superController shouldAddNewProjectWithName:nameField.text color:projectColor client:clientField.text];
	
	[self.superController dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
	// Do nothing...
	[self.superController dismissModalViewControllerAnimated:YES];
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
		[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return NSLocalizedString(@"Project Name", @"Title for the textField where the project name is supposed to be entered");
		case 1: return NSLocalizedString(@"Color", @"Title for the place where the user can select a color for the project");
		case 2: return NSLocalizedString(@"Client", @"Title for the client textField");
	} 
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
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
			[cell.contentView addSubview:nameField];
			break;
		case 1:
			c= cell.contentView.frame;
			c.size.width-= 20;
			colorPicker.frame= c;
			[cell.contentView addSubview:colorPicker];
			break;
		case 2:
			[cell.contentView addSubview:clientField];
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
