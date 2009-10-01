//
//  WTTrackingDetails.m
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTTrackingDetails.h"
#import "WTConstants.h"

@implementation WTTrackingDetails

- (id)initWithTrackingInterval:(NSMutableDictionary *)pTrackingInterval {
	if (self= [super init]) {
		trackingInterval= pTrackingInterval;
		self.title= [trackingInterval objectForKey:cProject];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect screen= [UIScreen mainScreen].applicationFrame;
	self.view= [[UIView alloc] initWithFrame:screen];
	
	self.view.backgroundColor= [UIColor groupTableViewBackgroundColor];
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
