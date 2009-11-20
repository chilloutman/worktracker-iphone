//
//  WTInfo.m
//  WorkTracker
//
//  Created by Lucas Neiva on 30.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTInfo.h"


@implementation WTInfo

@synthesize superController;

- (void)loadView {	
	CGRect r= superController.view.frame;
	
	self.view= [[UIView alloc] initWithFrame:r];
	self.view.backgroundColor= [UIColor viewFlipsideBackgroundColor];
	
	UIButton *doneButton= [UIButton buttonWithType:UIButtonTypeInfoLight];
	[doneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
	doneButton.center= CGPointMake(r.size.width-15, r.origin.y+15);
	[self.view addSubview:doneButton];
		
	// TODO: UIImageView with the application logo :-D
	UIImageView *iconView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
	iconView.frame= CGRectMake(0.0, 0.0, r.size.width-180, r.size.width-180);
	iconView.center= CGPointMake(r.size.width/2, r.size.height/2-(iconView.frame.size.height-30.0));
	[self.view addSubview:iconView];
	[iconView release];
	
	UILabel *wtLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, r.size.width-30, 60)];
	wtLabel.center= CGPointMake(r.size.width/2, r.size.height/2);
	wtLabel.textAlignment= UITextAlignmentCenter;
	wtLabel.text= @"WorkTracker";
	wtLabel.font= [UIFont systemFontOfSize:24];
	wtLabel.textColor= [UIColor whiteColor];
	wtLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:wtLabel];
	[wtLabel release];
	
	UILabel *versionLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, r.size.width-30, 20)];;
	versionLabel.center= CGPointMake(r.size.width/2, r.size.height/2+16);
	versionLabel.textAlignment= UITextAlignmentCenter;
	versionLabel.text= @"Version: alpha";
	versionLabel.font= [UIFont systemFontOfSize:13];
	versionLabel.textColor= [UIColor whiteColor];
	versionLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:versionLabel];
	[versionLabel release];
	
	UITextView *glyphishLabel= [self infoTextViewWithText:@"The icons used in this app where created by glyphish.com and kindly published under the Creatives Commons licence"];
	glyphishLabel.center= CGPointMake(r.size.width/2, 280.0);
	[self.view addSubview:glyphishLabel];						
}

- (UITextView *)infoTextViewWithText:(NSString *)text {
	CGSize size= [text sizeWithFont:[UIFont systemFontOfSize:14]];
	NSInteger numberOfLines= roundf(size.width / 290 + 0.5);
	
	UITextView *textView= [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, (numberOfLines+1) * size.height)];
	textView.text= text;
	textView.textAlignment= UITextAlignmentCenter;
	textView.textColor= [UIColor whiteColor];
	textView.font= [UIFont systemFontOfSize:14];
	textView.backgroundColor= [UIColor clearColor];
	textView.scrollEnabled= NO;
	textView.editable= NO;
	
	return [textView autorelease];
}

- (void)viewDidAppear:(BOOL)a {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (void)viewDidDisappear:(BOOL)a {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark Button

- (void)dismiss {
	[superController dismissModalViewControllerAnimated:YES];
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
