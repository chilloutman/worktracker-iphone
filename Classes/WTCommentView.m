//
//  WTCommentView.m
//  WorkTracker
//
//  Created by Lucas Neiva on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTCommentView.h"

@implementation WTCommentView

@synthesize commentField;

- (void)loadView {
	self.title= NSLocalizedString(@"Edit Comment", @"");
	
	CGRect screen= [UIScreen mainScreen].bounds;
	self.view= [[UIView alloc] initWithFrame:screen];
	[self.view release];
	self.view.backgroundColor= [UIColor groupTableViewBackgroundColor];
	
	CGRect textRect= CGRectMake(10.0, 15.0, 300.0, 170.0);
	
	// TextView to fake the look
	UITextField *textField= [[UITextField alloc] initWithFrame:textRect];
	textField.borderStyle= UITextBorderStyleRoundedRect;
	[self.view addSubview:textField];
	[textField release];
	
	// Actual textView
	commentField= [[UITextView alloc] initWithFrame:textRect];
	commentField.font= [UIFont systemFontOfSize:16];
	commentField.backgroundColor= [UIColor clearColor];
	[self.view addSubview:commentField];
	[commentField release];
}

- (void)viewWillAppear:(BOOL)animated {
	[commentField becomeFirstResponder];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
