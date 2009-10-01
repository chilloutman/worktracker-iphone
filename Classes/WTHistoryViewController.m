//
//  WTStatisticsViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTHistoryViewController.h"

#import "WTTableViewCell.h"
#import "WTTableSectionHeader.h"

#import "WTSort.h"
#import "WTDataModel.h"
#import "WTEngine.h"

#import "WTConstants.h"
#import "WTUtil.h"

@implementation WTHistoryViewController

@synthesize model;
@synthesize engine;

#pragma mark Build
- (id)init {
	if (self= [super init]) {
		self.tabBarItem= [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"History", @"Previous trackings") image:[UIImage imageNamed:@"backwards.png"] tag:2];
		self.model= [WTDataModel sharedDataModel];
		self.engine= [WTEngine sharedEngine];
		tableModel= [WTSort sharedSortingModel];
	}
	return self;
}

- (void)loadView {
	CGRect screen= [UIScreen mainScreen].bounds;
	
	self.view= [[[UIView alloc] initWithFrame:screen] autorelease];
	
	// TableView
	
	tableView= [[UITableView alloc] initWithFrame:screen style:UITableViewStylePlain];
	tableView.delegate= self;
	tableView.dataSource= self;
	tableView.allowsSelection= NO;
	
	// viewController
	
	UIViewController *tableController= [[UIViewController alloc] init];
	tableController.view= tableView;
	tableController.title= self.tabBarItem.title;
	tableController.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear", @"Delete some trackings")
																						style:UIBarButtonItemStyleBordered
																					   target:self action:@selector(clearIntervals)];
	// Toolbar
	UISegmentedControl *segmentedControl= [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Days", @"Segment, Show items from the last few days"),
																											  NSLocalizedString(@"Weeks", @"Show Items sorted by weeks"),
																											  NSLocalizedString(@"Months", @"ShowItems sorted by Months"), nil]];
	[segmentedControl addTarget:self action:@selector(segmentedControlSelectionDidChange:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle= UISegmentedControlStyleBar;
	segmentedControl.selectedSegmentIndex= 0;
	tableController.navigationItem.titleView= segmentedControl;
	
	//UIBarButtonItem *barItem= [[[UIBarButtonItem alloc] initWithCustomView:segmentedControl] autorelease];
	//UIBarButtonItem *space= [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	//tableController.toolbarItems= [NSArray arrayWithObjects:space, barItem, space, nil];
	
	// NavigationController
	
	navController= [[UINavigationController alloc] initWithRootViewController:tableController];
	[tableController release];
	//navController.toolbarHidden= NO;
	navController.toolbar.barStyle= UIBarStyleBlackTranslucent;
	
	[self.view addSubview:navController.view];
}

#pragma mark UI refresh

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// TODO: can't update cells because of a "tableView fail" when refreshing. Currently not displaying active/running stuff at all. Excuse: Because of 'History'...
	
	[tableView reloadData];
}

#pragma mark Buttons

// Clear

- (void)clearIntervals {
	UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Clear trackings", @"Title for delete confirmation")
															delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											  destructiveButtonTitle:NSLocalizedString(@"Delete all", @"")
												   otherButtonTitles:NSLocalizedString(@"Delete old ones", @""), nil];

	[actionSheet showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[actionSheet release];
		
	if (buttonIndex == 0) {
		// Delete everything
		[self.model deleteTrackingIntervals:YES];
		
		[tableModel invalidateSectionsForSortingType:WTSortingByAll];
		[tableView reloadData];
	} else if (buttonIndex == 1) {
		[self.model deleteTrackingIntervals:NO];
		
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

#pragma mark tableView dataSource / delegate

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

#pragma mark -

- (void)dealloc {
	[navController release];
	[tableView release];
	[self.model release];
    [super dealloc];
}


@end
