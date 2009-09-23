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
	
	self.view= [[[UIView alloc] initWithFrame:screen] autorelease];
	self.view.backgroundColor= [UIColor groupTableViewBackgroundColor];
	
	/*
	UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 50)];
	titleLabel.text= NSLocalizedString(@"Enter a name for the new project", @"Ask the user for a project name");
	titleLabel.textAlignment= UITextAlignmentCenter;
	titleLabel.backgroundColor= [UIColor lightGrayColor];
	titleLabel.numberOfLines= 2;
	titleLabel.font= [UIFont fontWithName:titleLabel.font.fontName size:18];
	[self.view addSubview:titleLabel];
	[titleLabel release];
	
	textField= [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 280, 30)];
	textField.borderStyle= UITextBorderStyleRoundedRect;
	[textField setFont:[UIFont systemFontOfSize:16]];
	[self.view addSubview:textField];
	
	UIButton *doneButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	doneButton.frame= CGRectMake(170, 160, 120, 50);
	[doneButton setTitle:NSLocalizedString(@"Add", @"") forState: UIControlStateNormal];
	[doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:doneButton];
	
	UIButton *cancelButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	cancelButton.frame= CGRectMake(20, 160, 120, 50);
	[cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState: UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancelButton];
	*/
	
	// Toolbar
	
	UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
	doneButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStyleDone target:self action:@selector(done)];
	doneButton.enabled= NO;
	UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 45)];
	[toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, doneButton, nil]];
	[self.view addSubview:toolbar];
	
	[toolbar release];
	[cancelButton release];
	[flexSpace release];
	
	// ---
	
	UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(15, 60, screen.size.width-30, 60)];
	titleLabel.text= NSLocalizedString(@"Enter a name for the new project", @"Ask the user for a project name");
	titleLabel.textAlignment= UITextAlignmentCenter;
	titleLabel.backgroundColor= [UIColor clearColor];
	titleLabel.numberOfLines= 2;
	titleLabel.font= [UIFont fontWithName:titleLabel.font.fontName size:18];
	[self.view addSubview:titleLabel];
	[titleLabel release];
	
	textField= [[UITextField alloc] initWithFrame:CGRectMake(15, 135, screen.size.width - 30, 30)];
	textField.borderStyle= UITextBorderStyleRoundedRect;
	[textField setFont:[UIFont systemFontOfSize:16]];
	textField.returnKeyType= UIReturnKeyDone;
	textField.delegate= self;
	[self.view addSubview:textField];
	
	// TODO: select a color for the proj.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	textField.text= nil;
	[textField becomeFirstResponder];
}

#pragma mark Buttons

- (void)done {
	if ([textField.text isEqualToString:@""] || textField.text == nil) {
		return;
	}
	[self.superController shouldAddNewProjectWithName:textField.text];
	
	[self.superController dismissModalViewControllerAnimated:YES];
}

- (void)cancel {
	// Do nothing...
	[self.superController dismissModalViewControllerAnimated:YES];
}

#pragma mark textField delegate & KVO
- (BOOL)textFieldShouldReturn:(UITextField *)tF {
	if ([textField.text isEqualToString:@""] || textField.text == nil) {
		return NO;
	}
	
	[self done];
	return YES;
}

#pragma mark -

- (void)dealloc {
	[textField release];
	[doneButton release];
	[self.superController release];
    [super dealloc];
}


@end
