//
//  WTProjectPicker.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTProjectPicker.h"
#import	"WTMainViewController.h"
#import "WTDataModel.h"

#import "WTConstants.h"

@implementation WTProjectPicker

@synthesize picker;
@synthesize superController;

#pragma mark Build

- (id)init {
	if (self= [super init]) {
	}
	return self;
}

- (void)loadView {
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	self.view= [[[UIView alloc] initWithFrame:screen] autorelease];
	self.view.backgroundColor= [UIColor groupTableViewBackgroundColor];
	/*
	UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 60)];
	titleLabel.text= NSLocalizedString(@"Pick the project you\nwould like to track", @"Ask user to select a project");
	titleLabel.textAlignment= UITextAlignmentCenter;
	titleLabel.backgroundColor= [UIColor lightGrayColor];
	titleLabel.numberOfLines= 2;
	titleLabel.font= [UIFont fontWithName:titleLabel.font.fontName size:18];
	[self.view addSubview:titleLabel];
	
	self.picker= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 110, screen.size.width, 220)];
	picker.delegate= self;
	picker.dataSource= self;
	picker.showsSelectionIndicator= YES;
	[self.view addSubview:self.picker];
	
	UIButton *okButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[okButton setTitle:@"Ok" forState:UIControlStateNormal];
	[okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	okButton.frame= cButtonFrame;
	okButton.center= CGPointMake(240, 385);
	[okButton addTarget:self action:@selector(projectWasSelected) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:okButton];
	
	UIButton *cancelButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[cancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	cancelButton.frame= cButtonFrame;
	cancelButton.center= CGPointMake(80, 385);
	[cancelButton addTarget:self action:@selector(userCanceled) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancelButton];
	*/
	
	// Toolbar
	
	UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(userCanceled)];
	UIBarButtonItem *okButton= [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(projectWasSelected)];
	UIBarButtonItem *flexSpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIToolbar *toolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, 45)];
	[toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexSpace, okButton, nil]];
	[self.view addSubview:toolbar];
	
	[toolbar release];
	[cancelButton release];
	[okButton release];
	[flexSpace release];
	
	// ---
	
	UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(15, 60, screen.size.width-30, 60)];
	titleLabel.text= NSLocalizedString(@"Pick the project you would like to track", @"Ask user to select a project");
	titleLabel.textAlignment= UITextAlignmentCenter;
	titleLabel.numberOfLines= 2;
	titleLabel.backgroundColor= [UIColor clearColor];
	titleLabel.font= [UIFont fontWithName:titleLabel.font.fontName size:18];
	[self.view addSubview:titleLabel];
	[titleLabel release];
	
	self.picker= [[UIPickerView alloc] initWithFrame:CGRectMake(0, 135, screen.size.width, 220)];
	picker.delegate= self;
	picker.dataSource= self;
	picker.showsSelectionIndicator= YES;
	[self.view addSubview:self.picker];
}

- (void)viewWillAppear:(BOOL)animated {
	[picker reloadComponent:0];
	[super viewWillAppear:animated];
}

#pragma mark Serve the UIPickerView

// With the picker the user can select wich project should be tracked 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)c {
	return [superController.model.projects count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)c {
	return [superController.model.projects objectAtIndex:row];
}


#pragma mark Buttons

- (void)projectWasSelected {
	// Nofify the mainView that a proj. was selectet
	[superController userPickedProjectAtIndex:[picker selectedRowInComponent:0]];
}

- (void)userCanceled {
	[superController userCanceledProjectPicker];
}

#pragma mark -

- (void)dealloc {
	[self.picker release];
	[self.superController release];
	[super dealloc];
}


@end
