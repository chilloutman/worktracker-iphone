//
//  WTTrackingIntervals.m
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTTrackingIntervals.h"
#import "WTHistoryViewController.h"

#import "WTTableViewCell.h"
#import "WTTableSectionHeader.h"

#import "WTSort.h"
#import "WTDataModel.h"
#import "WTEngine.h"

#import "WTConstants.h"
#import "WTUtil.h"

@implementation WTTrackingIntervals

@synthesize superController;

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
		engine= [WTEngine sharedEngine];
		tableModel= [WTSort sharedSortingModel];
		
		self.title= NSLocalizedString(@"History", @"Previous trackings");
		
		UISegmentedControl *segmentedControl= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Days", @"Segment, Show items from the last few days"),
																						 NSLocalizedString(@"Weeks", @"Show Items sorted by weeks"),
																						 NSLocalizedString(@"Months", @"ShowItems sorted by Months"), nil]];
		[segmentedControl addTarget:self action:@selector(segmentedControlSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.segmentedControlStyle= UISegmentedControlStyleBar;
		segmentedControl.selectedSegmentIndex= 0;
		self.navigationItem.titleView= segmentedControl;
		[segmentedControl release];
		
		UIBarButtonItem *deleteButton= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", @"Delete some trackings")
																			style:UIBarButtonItemStyleBordered
																		   target:self action:@selector(clearIntervals)];
		self.navigationItem.rightBarButtonItem= deleteButton;
		[deleteButton release];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	
	tableView= [[UITableView alloc] initWithFrame:screen style:UITableViewStylePlain];
	tableView.delegate= self;
	tableView.dataSource= self;
	
	
	self.view= tableView;
}

#pragma mark UI refresh

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:(BOOL)animated];
	// TODO: can't update cells because of a "tableView fail" when refreshing. Currently not displaying active/running stuff at all. Excuse: Because of 'History'...
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
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
		[model deleteTrackingIntervals:YES];
		
		[tableModel invalidateSectionsForSortingType:WTSortingByAll];
		[tableView reloadData];
	} else if (buttonIndex == 1) {
		[model deleteTrackingIntervals:NO];
		
		[tableModel invalidateSectionsForSortingType:WTSortingByAll];
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
	
	WTTableViewCell *cell= (WTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[WTTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	
	NSMutableDictionary *trackingInterval= [[[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	cell.firstText= [WTUtil formattedProjectNameForTrackingInterval:trackingInterval];
	cell.lastText= [WTUtil formattedTimeIntervalForTrackingInterval:trackingInterval decimal:YES];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tV viewForHeaderInSection:(NSInteger)section {
	WTTableSectionHeader *tableHeader= [[[WTTableSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
	
	NSMutableArray *headerTitles= [tableModel headerTitlesForSortingType:activeSortingType];
	tableHeader.firstText= [headerTitles objectAtIndex:section];
	NSMutableArray *sectionArray= [[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:section];
	tableHeader.lastText= [WTUtil totalTimeForSection:sectionArray withActive:NO];
	
	return tableHeader;
}

#pragma mark tableView selection

- (void)tableView:(UITableView *)tV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *selectedInterval= [[[tableModel sectionArrayForSortingType:activeSortingType] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	// The superController knows how to push the detailView
	[superController pushDetailViewWithInterval:selectedInterval];
}
	 
#pragma mark -

- (void)dealloc {
	[tableView release];
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

