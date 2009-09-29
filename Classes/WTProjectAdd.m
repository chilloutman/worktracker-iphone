//
//  WTProjectAddViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 09.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjectAdd.h"
#import "WTProjectsViewController.h"

#import "WTConstants.h"

@implementation WTProjectAdd

@synthesize superController;

#pragma mark Build

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	
	self.view= [[UIView alloc] initWithFrame:screen];
	
	tableView= [[UITableView alloc] initWithFrame:CGRectMake(screen.origin.x, screen.origin.y + 23, screen.size.width, screen.size.height - 45) style:UITableViewStyleGrouped];
	tableView.dataSource= self;
	tableView.delegate= self;
	
	// Toolbar
	
	UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	doneButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStyleDone target:self action:@selector(done)];
	doneButton.enabled= YES;
	UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *title= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New Project", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
	
	UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 45)];
	[toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, title, flexSpace, doneButton, nil]];
	[self.view addSubview:toolbar];
	
	[toolbar release];
	[cancelButton release];
	[flexSpace release];
	
	// ---
	
	nameField= [[UITextField alloc] init];
	nameField.adjustsFontSizeToFitWidth= YES;
	//[nameField setFont:[UIFont systemFontOfSize:22]];
	nameField.autocorrectionType= UITextAutocorrectionTypeNo;
	nameField.autocapitalizationType= UITextAutocapitalizationTypeNone;
	nameField.returnKeyType= UIReturnKeyDone;
	nameField.clearButtonMode= UITextFieldViewModeWhileEditing;
	
	[self.view addSubview:tableView];
	
	// TODO: select a color for the proj. - UISegmentControl
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	nameField.text= nil;
	[nameField becomeFirstResponder];
}

#pragma mark Buttons

- (void)done {
	if ([nameField.text isEqualToString:@""] || nameField.text == nil) {
		return;
	}
	[self.superController shouldAddNewProjectWithName:nameField.text];
	
	[self.superController dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
	// Do nothing...
	[self.superController dismissModalViewControllerAnimated:YES];
}

#pragma mark UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)pTableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return @"Project Name";
		case 1: return @"Project Color";
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
	
	CGRect rect= CGRectInset(cell.contentView.bounds, 20.0, 10.0);
	
	switch (indexPath.section) {
		case 0:
			nameField.frame= rect;
			[cell.contentView addSubview:nameField];
			break;
		case 1:
			break;
	}
	
	
	return cell;
}

#pragma mark -

- (void)dealloc {
	[nameField release];
	[doneButton release];
	[self.superController release];
    [super dealloc];
}


@end
