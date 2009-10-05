//
//  WTTrackingDetails.m
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTTrackingDetails.h"

#import "WTConstants.h"
#import "WTUtil.h"

@implementation WTTrackingDetails

- (id)initWithTrackingInterval:(NSMutableDictionary *)pTrackingInterval {
	if (self= [super init]) {
		trackingInterval= pTrackingInterval;
		self.title= [trackingInterval objectForKey:cProject];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	tableView= [[UITableView alloc] initWithFrame:screen style:UITableViewStyleGrouped];
	tableView.delegate= self;
	tableView.dataSource= self;
	tableView.allowsSelection= NO;
		
	self.view= tableView;
}

#pragma mark UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)pTableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return [WTUtil dateForDate:[trackingInterval objectForKey:cStartTime]];
		case 1: return nil;
		default: return nil;
	} 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: return 2;
		case 1: return 1;
		default: return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"cellID";
	
	UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
		cell.selectionStyle= UITableViewCellSelectionStyleNone;
	}
	
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0) {
				cell.textLabel.text= NSLocalizedString(@"Start Time", @"");
				cell.detailTextLabel.text= [WTUtil timeForDate:[trackingInterval objectForKey:cStartTime]];
			} else {
				cell.textLabel.text= NSLocalizedString(@"Stop Time", @"");
				cell.detailTextLabel.text= [WTUtil timeForDate:[trackingInterval objectForKey:cStopTime]];
			}
			break;
		case 1:
			cell.textLabel.text= NSLocalizedString(@"Tracked Time", @"");
			cell.detailTextLabel.text= [WTUtil formattedTimeInterval:[[trackingInterval objectForKey:cTimeInterval] doubleValue] decimal:NO];
			break;
	}
	
	return cell;
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
