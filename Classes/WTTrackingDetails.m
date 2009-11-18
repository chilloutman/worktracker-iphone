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
		displayingComment= ([trackingInterval objectForKey:cComment] != nil);
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	tableView= [[UITableView alloc] initWithFrame:screen style:UITableViewStyleGrouped];
	tableView.delegate= self;
	tableView.dataSource= self;
	tableView.allowsSelection= NO;
	
	if (displayingComment) {
		NSString *comment= [[trackingInterval objectForKey:cComment] copy];
		CGSize labelSize= [comment sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(280.0, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
		commentLabel= [[UITextView alloc] initWithFrame:CGRectMake(2.0, 34.0, 292.0, labelSize.height + 10.0)];
		commentLabel.editable= NO;
		commentLabel.scrollEnabled= NO;
		commentLabel.text= comment;
		commentLabel.textColor= [UIColor colorWithRed:0.2 green:0.3 blue:0.5 alpha:1.0];
		commentLabel.font= [UIFont systemFontOfSize:14.0];
		[comment release];
	}
		
	self.view= tableView;
}

#pragma mark UITableView delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tV {
	if (displayingComment) return 2;
	else return 1;
}

- (NSString *)tableView:(UITableView *)tV titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return [WTUtil dateForDate:[trackingInterval objectForKey:cStartTime]];
		case 1: return nil;
		default: return nil;
	} 
}

- (NSInteger)tableView:(UITableView *)tV numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: return 3;
		case 1: return 1;
		default: return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tV heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) return 44 + commentLabel.frame.size.height;
	else return 44;
}

- (UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"cellID";
	
	UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID] autorelease];
		cell.selectionStyle= UITableViewCellSelectionStyleNone;
	}
	
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text= NSLocalizedString(@"Start Time", @"");
				cell.detailTextLabel.text= [WTUtil timeForDate:[trackingInterval objectForKey:cStartTime]];
				break;
			case 1:
				cell.textLabel.text= NSLocalizedString(@"Stop Time", @"");
				cell.detailTextLabel.text= [WTUtil timeForDate:[trackingInterval objectForKey:cStopTime]];
			case 2:
				cell.textLabel.text= NSLocalizedString(@"Tracked Time", @"");
				cell.detailTextLabel.text= [WTUtil formattedTimeInterval:[[trackingInterval objectForKey:cTimeInterval] doubleValue] decimal:NO];
				break;
		}
	} else {
		UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 280.0, 44.0)];
		titleLabel.text= NSLocalizedString(@"Comment", @"");
		titleLabel.font= [UIFont boldSystemFontOfSize:16.0];
		
		[cell.contentView addSubview:titleLabel];
		[cell.contentView addSubview:commentLabel];
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
