//
//  WTProjectDetails.m
//  WorkTracker
//
//  Created by Lucas Neiva on 02.10.09.
//  ***
//

#import "WTProjectDetails.h"

#import "WTProjects.h"

#import "WTConstants.h"
#import "WTUtil.h"

@implementation WTProjectDetails

@synthesize activities;

- (id)initWithProject:(NSMutableDictionary *)pProject name:(NSString *)pProjectName activities:(NSArray *)pActivities {
	if (self= [super init]) {
		project= pProject;
		self.activities= ([pActivities count] > 0) ? pActivities : nil;
		
		self.title= NSLocalizedString(@"Details", @"Title for detail view");
		projectName= [pProjectName copy];
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
	if (activities) return 3;
	else return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0: return nil;
		case 1: return nil;
		case 2: return NSLocalizedString(@"Tracking Intervals", @"");
		default: return nil;
	} 
}

- (NSInteger)tableView:(UITableView *)tV numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0: return 3;
		case 1: return 2;
		case 2: return [activities count];
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
	
	NSMutableDictionary *interval;
	
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0) {
				cell.textLabel.text= NSLocalizedString(@"Project Name", @"");
				cell.detailTextLabel.text= projectName;
			} else if (indexPath.row == 1) {
				cell.textLabel.text= NSLocalizedString(@"Client", @"");
				cell.detailTextLabel.text= [project objectForKey:cProjectClient];
			} else {
				cell.textLabel.text= NSLocalizedString(@"Color", @"");
				UIView *colorView= [[UIView alloc] initWithFrame:CGRectMake(160, 6, 130, 31)];
				colorView.backgroundColor= [NSKeyedUnarchiver unarchiveObjectWithData:[project objectForKey:cProjectColor]];
				[cell.contentView addSubview:colorView];
				[colorView release];
			}

			break;
		case 1:
			if (indexPath.row == 0) {
				cell.textLabel.text= NSLocalizedString(@"Number of activities", @"");
				cell.detailTextLabel.text= [[project objectForKey:cProjectNumber] stringValue];
			} else {
				cell.textLabel.text= NSLocalizedString(@"Total Time", @"");
				cell.detailTextLabel.text= [WTUtil formattedTimeInterval:[[project objectForKey:cProjectTime] doubleValue] decimal:NO];
			}
			break;
		case 2:
			interval= [activities objectAtIndex:indexPath.row];
			
			cell.textLabel.text= [WTUtil shortDateForDate:[interval objectForKey:cStartTime]];
			cell.detailTextLabel.text= [WTUtil formattedTimeInterval:[[interval objectForKey:cTimeInterval] doubleValue] decimal:NO];
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
}

- (void)dealloc {
	[projectName release];
    [super dealloc];
}

@end
