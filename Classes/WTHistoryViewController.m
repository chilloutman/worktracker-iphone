//
//  WTStatisticsViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTHistoryViewController.h"

#import "WTTableBackgorund.h"
#import "WTTableViewCell.h"
#import "WTTableSectionHeader.h"

#import "WTSort.h"
#import "WTDataModel.h"
#import "WTEngine.h"

#import "WTConstants.h"

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
	
	// Create a view with a gray background for the top
	tableView.tableHeaderView= [[[WTTableBackgorund alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height / 2)] autorelease];
	// Have the tableview ignore our headerView when computing size
	tableView.contentInset = UIEdgeInsetsMake(-(tableView.tableHeaderView.frame.size.height), 0, 0, 0);
	
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
	
	[tableModel setupSections:activeSortingType];
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
		[self.model deleteTrackingIntervals:YES];
		[tableView reloadData];
		//[tableView deleteSections:[NSIndexSet ind] withRowAnimation:UITableViewRowAnimationTop];
	} else if (buttonIndex == 1) {
		[self.model deleteTrackingIntervals:NO];
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:5] withRowAnimation:UITableViewRowAnimationTop];
	} else {
		return;
	}

	[tableView reloadData];
}

// SegmentControl

- (void)segmentedControlSelectionDidChange:(UISegmentedControl *)segmentedControl {
	activeSortingType=(WTSortingType) segmentedControl.selectedSegmentIndex;
	[tableView reloadData];
	return;
}

#pragma mark tableView dataSource / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)pTableView {
	return [tableModel numberOfSectionsForSortingType:activeSortingType];
}

- (NSInteger)tableView:(UITableView *)pTableView numberOfRowsInSection:(NSInteger)section {
	return [tableModel numberOfIntervalsForSection:section withSortingType:activeSortingType];
}

- (UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"ABCell";
	
	WTTableViewCell *cell= (WTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[WTTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	
	NSInteger index= indexPath.row; // indexPath.row is just the row inside the section
	if ([self.engine running]) index++; // Skip the active one
	// Add the previous section counts to find the position inside the Array
	for (int i= 0; i < indexPath.section; i++) {
		index+= [tableModel numberOfIntervalsForDay:i withActive:NO];
	}
	NSMutableDictionary *trackingInterval= [self.model.trackingIntervals objectAtIndex:index];
	
	cell.firstText= [self.model formattedProjectNameForTrackingInterval:trackingInterval];
	cell.lastText= [self.model formattedTimeIntervalForTrackingInterval:trackingInterval decimal:YES];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tV viewForHeaderInSection:(NSInteger)section {
	// Cache because this gets called all the time and slows down scrolling
	
	NSMutableArray *headerTitles= [tableModel headerTitlesForSortingType:activeSortingType];
	
	WTTableSectionHeader *tableHeader= [[[WTTableSectionHeader alloc] initWithFrame:CGRectZero] autorelease];
	tableHeader.firstText= [headerTitles objectAtIndex:section];
	tableHeader.lastText= [self.model formattedTotalTimeForDay:section withActive:NO];
	
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
