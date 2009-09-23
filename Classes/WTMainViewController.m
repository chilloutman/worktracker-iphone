//
//  WTMainViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTMainViewController.h"
#import "WTProjectPicker.h"

#import "WTMainBackgroundView.h"
#import "WTTableViewCell.h"
#import "WTTableSectionHeader.h"

#import "WTDataModel.h"
#import "WTEngine.h"
#import "WTSort.h"

#import "WTConstants.h"

@implementation WTMainViewController

@synthesize model;
@synthesize engine;

#pragma mark Build

- (id)init{
	if (self= [super init]) {
		self.tabBarItem= [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Track", @"tabBarTitle") image:[UIImage imageNamed:@"clock.png"] tag:0];
		self.model= [WTDataModel sharedDataModel];
		self.engine= [WTEngine sharedEngine];
		tableModel= [WTSort sharedSortingModel];
	}
	return self;
}

- (void)loadView {
	CGRect screen = [[UIScreen mainScreen] applicationFrame];

	self.view= [[WTMainBackgroundView alloc] initWithFrame:screen];
	
	// label that shows the current status
	
	statusLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 25, screen.size.width, 25)];
	statusLabel.textAlignment= UITextAlignmentCenter;
	statusLabel.textColor= [UIColor whiteColor];
	statusLabel.font= [UIFont boldSystemFontOfSize:20];
	statusLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:statusLabel];
		
	// Start & Stop buttons

	startButton= [UIButton buttonWithType:UIButtonTypeCustom];
	startButton.frame= cButtonFrame;
	startButton.center= CGPointMake(80, 100);
	[startButton setTitle:@"Start" forState: UIControlStateNormal];
	
	startButton.titleLabel.font= [UIFont boldSystemFontOfSize:18];
	[startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[startButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	[startButton setBackgroundImage:[[UIImage imageNamed:@"greenButton.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
	[startButton setBackgroundImage:[[UIImage imageNamed:@"blackButton.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateDisabled];
	
	[startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:startButton];
	
	stopButton= [UIButton buttonWithType:UIButtonTypeCustom];
	stopButton.frame= cButtonFrame;
	stopButton.center= CGPointMake(80, 170);
	[stopButton setTitle:@"Stop" forState: UIControlStateNormal];
	
	stopButton.titleLabel.font= [UIFont boldSystemFontOfSize:18];
	[stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[stopButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	[stopButton setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:10] forState:UIControlStateNormal];
	[stopButton setBackgroundImage:[[UIImage imageNamed:@"blackButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateDisabled];
	
	[stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stopButton];
	
	//  Start- & stoptime labels
	
	startTimeLabel= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 50)];
	startTimeLabel.center= CGPointMake(240, 100);
	startTimeLabel.textAlignment= UITextAlignmentCenter;
	startTimeLabel.textColor= [UIColor whiteColor];
	startTimeLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:startTimeLabel];

	stopTimeLabel= [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 50)];
	stopTimeLabel.center= CGPointMake(240, 170);
	stopTimeLabel.textAlignment= UITextAlignmentCenter;
	stopTimeLabel.textColor= [UIColor whiteColor];
	stopTimeLabel.backgroundColor= [UIColor clearColor];
	[self.view addSubview:stopTimeLabel];
	
	// TableView with todays trackingIntervals
	
	tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, screen.size.height / 2 + 2, screen.size.width, (screen.size.height / 2) - 48) style:UITableViewStylePlain];
	tableView.dataSource= self;
	tableView.delegate= self;
	tableView.backgroundColor= [UIColor clearColor];
	tableView.allowsSelection= NO;
	tableView.separatorColor= cColorLightGray;
	tableView.rowHeight-= 5;
	[self.view addSubview:tableView];
}

#pragma mark UI refresh

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([self.engine running]) {
		// Update the first cells time which is counting
		[self.engine pingEvery:cTimeRefreshRate target:self selector:@selector(updateActiveElements:) identifier:cTimerMainView];
	}
	
    [self updateUIElements];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if ([self.engine running]) {
		[self.engine stopPinging:cTimerMainView];
	}
}

- (void)updateActiveElements:(NSTimer *)theTimer {
	// Active table cell
	WTTableViewCell *cell= (WTTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	cell.lastText= [self.model formattedTimeIntervalForTrackingInterval:nil decimal:YES];
	
	// Table header
	tableHeader.lastText= [self.model formattedTotalTimeForDay:0 withActive:YES];
}

- (void)updateUIElements {
	// Make Default.png
	//	statusLabel.text= @"Loading";
	//	startTimeLabel= @"";
	//	stopTimeLabel= @"";
	//	
	//	startButton.enabled= NO;
	//	stopButton.enabled= NO;
	
	// Update Labels
	statusLabel.text= [self.model formattedStatus];
	startTimeLabel.text= [self.model formattedStartTimeForTrackingInterval:nil];
	stopTimeLabel.text= [self.model formattedStopTimeForTrackingInterval:nil];
	
	// Update Buttons
	if ([self.engine running]) {
		startButton.enabled= NO;
		stopButton.enabled= YES;
	} else if ([self.model.projects count] == 0) {
		// There are no projects we can track
		startButton.enabled= NO;
		stopButton.enabled= NO;
	} else {
		// Good to go
		startButton.enabled= YES;
		stopButton.enabled= NO;			
	}
	
	// Update tableView
	[tableView reloadData];
}

#pragma mark Handle buttons

- (void)start {
	if (projectPicker == nil) {
		projectPicker= [[WTProjectPicker alloc] init];
		projectPicker.superController= self;
	}
	
	// projectPicker lets the user select a proj. whitch is then send to the model
	[self presentModalViewController:projectPicker animated:YES];
	
	// Now we wait until a project gets picked
}
- (void)userPickedProjectAtIndex: (NSInteger)index {
	if (index >= 0) {
		[self.engine startTrackingProjectAtIndex:index];
		
		[self updateUIElements];
		[self.engine pingEvery:cTimeRefreshRate target:self selector:@selector(updateActiveElements:) identifier:cTimerMainView];
		
		// Dismiss the picker and move on
		[self dismissModalViewControllerAnimated:YES];
	} else {
		return;
	}
}
- (void)userCanceledProjectPicker {
	// Dismiss the picker and do nothing
	[self dismissModalViewControllerAnimated:YES];
}

- (void)stop {
	[self.engine stopTracking];
	[self.engine stopPinging:cTimerMainView];
	[self updateUIElements];
}

#pragma mark UITableView delegate / dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tV {
	// One is for the fake cells
	return 2;
}

//- (NSString *)tableView:(UITableView *)tV titleForHeaderInSection:(NSInteger)section {
//	if (section == 0) return NSLocalizedString(@"Today", @"");
//	else return nil;
//}

- (NSInteger)tableView:(UITableView *)tV numberOfRowsInSection:(NSInteger)section {
	// 0 == Today
	NSInteger numberOfRows= [tableModel numberOfIntervalsForDay:0 withActive:YES];
	
	if (section == 0) {
		return numberOfRows;
	} else {
		if (numberOfRows < 5) {
			numberOfFakeCells= 4 - numberOfRows;
		}
		return numberOfFakeCells;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"ABCell";
	
	WTTableViewCell *cell= (WTTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[WTTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	
	if (indexPath.section == 0) {
		NSMutableDictionary *interval= [self.model.trackingIntervals objectAtIndex:indexPath.row];
		cell.firstText= [self.model formattedProjectNameForTrackingInterval:interval];
		cell.lastText= [self.model formattedTimeIntervalForTrackingInterval:interval decimal:YES];
	} else {
		cell.firstText= @"";
		cell.lastText= @"";
	}
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tV viewForHeaderInSection:(NSInteger)section {
	// Keep a reference for updating
	if (!tableHeader) {
		tableHeader= [[WTTableSectionHeader alloc] initWithFrame:CGRectZero];
		tableHeader.firstText= NSLocalizedString(@"Today", @"");
		tableHeader.lastText= [self.model formattedTotalTimeForDay:0 withActive:YES];
	}

	if (section == 0) {
		return tableHeader;
	} else {
		return nil;
	}
}



#pragma mark -

- (void)dealloc {
	[tableView release];
	[tableHeader release];
	[statusLabel release];
	[startTimeLabel release];
	[stopTimeLabel release];
	[projectPicker release];
	[self.model release];
	[self.engine release];
	
	[super dealloc];
}


@end

