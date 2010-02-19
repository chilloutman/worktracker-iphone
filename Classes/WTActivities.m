//
//  WTActivities.m
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTActivities.h"
#import "WTOverviewRootController.h"
#import "WTTrackingDetails.h"

#import "WTIntervalCell.h"
#import "WTTableSectionHeader.h"

#import "WTSort.h"
#import "WTDataModel.h"
#import "WTEngine.h"

#import "WTConstants.h"
#import "WTUtil.h"

@implementation WTActivities

@synthesize superController, tableView;

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
		engine= [WTEngine sharedEngine];
		tableModel= [WTSort sharedSortingModel];
		
		self.title= NSLocalizedString(@"History", @"Previous trackings");
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	
	UISegmentedControl *segmentedControl= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Days", @"Segment, Show items from the last few days"),
																					 NSLocalizedString(@"Weeks", @"Show Items sorted by weeks"),
																					 NSLocalizedString(@"Months", @"ShowItems sorted by Months"), nil]];
	[segmentedControl addTarget:self action:@selector(segmentedControlSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle= UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex= 0;
	self.navigationItem.titleView= segmentedControl;
	[segmentedControl release];
	
	deleteButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", @"Delete some trackings")
												   style:UIBarButtonItemStyleBordered
												  target:self action:@selector(clearIntervals)];
	self.navigationItem.rightBarButtonItem= deleteButton;
	[deleteButton release];	
	
	self.tableView= [[UITableView alloc] initWithFrame:screen style:UITableViewStylePlain];
	self.tableView.delegate= self;
	self.tableView.dataSource= self;
	
	self.view= self.tableView;
}

#pragma mark UI refresh

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:(BOOL)animated];
	// TODO: can't update cells because of a "tableView fail" when refreshing. Currently not displaying active/running stuff at all. Excuse: Because of 'History'...
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
	
	deleteButton.enabled= ([model.activities count] > 0);
}

#pragma mark navigationBar Buttons

// Clear

- (void)clearIntervals {
	UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Clear trackings", @"Title for delete confirmation")
															delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											  destructiveButtonTitle:NSLocalizedString(@"Delete all", @"")
												   otherButtonTitles:NSLocalizedString(@"Delete old ones", @""), nil];
	
	[actionSheet showInView:self.superController.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[actionSheet release];
	
	if (buttonIndex == 0) {
		// Delete everything
		[model deleteAllActivities:YES];
		[tableModel invalidateSectionsForSortingType:WTSortingAll];
			
		[tableView reloadData];
	} else if (buttonIndex == 1) {
		[model deleteAllActivities:NO];
		[tableModel invalidateSectionsForSortingType:WTSortingAll];
		
		[tableView reloadData];
	}
}

// SegmentControl

- (void)segmentedControlSelectionDidChange:(UISegmentedControl *)segmentedControl {
	activeSortingType=(WTSortingType) segmentedControl.selectedSegmentIndex;
	[tableView reloadData];
	return;
}

#pragma mark tableView build

- (NSInteger)numberOfSectionsInTableView:(UITableView *)pTableView {
	return [[tableModel sectionArrayForSortingType:activeSortingType] count];
}

- (NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
	return [[[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"ABCell";
	
	WTIntervalCell *cell= (WTIntervalCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[WTIntervalCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	
	NSMutableDictionary *activities= [[[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	cell.firstText= [WTUtil formattedProjectNameForActivity:activities running:NO];
	cell.lastText= [WTUtil formattedTimeInterval:[model timeIntervalForActivity:activities] decimal:YES];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tV viewForHeaderInSection:(NSInteger)section {
	WTTableSectionHeader *tableHeader= [[[WTTableSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
	
	NSMutableArray *headerTitles= [tableModel headerTitlesForSortingType:activeSortingType];
	tableHeader.firstText= [headerTitles objectAtIndex:section];
	NSMutableArray *sectionArray= [[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:section];
	tableHeader.lastText= [WTUtil formattedTotalTimeForIntervals:sectionArray withActive:NO];
	
	return tableHeader;
}

#pragma mark tableView selection

- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *selectedInterval= [[[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	WTTrackingDetails *detailViewController= [[WTTrackingDetails alloc] initWithActivity:selectedInterval];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}
	 
#pragma mark -

- (void)dealloc {
	[self.tableView release];
	[superController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end

