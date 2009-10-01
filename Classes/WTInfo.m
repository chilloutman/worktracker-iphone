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
	versionLabel.center= CGPointMake(r.size.width/2, r.size.height/2+15);
	versionLabel.textAlignment= UITextAlignmentCenter;
	versionLabel.text= @"Version: alpha";
	versionLabel.font= [UIFont systemFontOfSize:13];
	versionLabel.textColor= [UIColor whiteColor];
	versionLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:versionLabel];
	[versionLabel release];
	
	UILabel *glyphishLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, r.size.width-30, 60)];
	glyphishLabel.center= CGPointMake(r.size.width/2, 280);
	glyphishLabel.textAlignment= UITextAlignmentCenter;
	glyphishLabel.text= @"The icons used in this app where created by glyphish.com and kindly published under the Creatives Commons licence";
	glyphishLabel.font= [UIFont systemFontOfSize:14];
	glyphishLabel.numberOfLines= 3;
	glyphishLabel.textColor= [UIColor whiteColor];
	glyphishLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:glyphishLabel];
	[glyphishLabel release];
							
}

- (void)viewWillAppear:(BOOL)a {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
}

- (void)viewWillDisappear:(BOOL)a {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

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
