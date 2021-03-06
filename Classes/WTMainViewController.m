//
//  WTMainViewController.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import "WTMainViewController.h"
#import "WTStartTrackingRootController.h"
#import "WTInfo.h"

#import "WTMainBackgroundView.h"
#import "WTIntervalCell.h"
#import "WTTableSectionHeader.h"

#import "WTDataModel.h"
#import "WTEngine.h"
#import "WTSort.h"
#import "WTUtil.h"

#import "WTConstants.h"

@interface WTMainViewController()
- (void)updateUIElements;
- (void)updateLabels;
- (void)updateButtons;
@end

@implementation WTMainViewController

@synthesize model;
@synthesize engine;

#pragma mark Build

- (id)init {
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
	
	// Label that shows the current status
	
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
	[startButton setTitle:@"Start..." forState: UIControlStateNormal];
	
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
	
	// TableView with todays activities
	
	tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, screen.size.height / 2 + 2, screen.size.width, (screen.size.height / 2) - 48) style:UITableViewStylePlain];
	tableView.dataSource= self;
	tableView.delegate= self;
	tableView.backgroundColor= [UIColor clearColor];
	tableView.allowsSelection= NO;
	tableView.separatorColor= cColorLightGray;
	tableView.rowHeight-= 5;
	[self.view addSubview:tableView];
	
	// Info button
	infoButton= [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(displayInfoPage) forControlEvents:UIControlEventTouchUpInside];
	infoButton.center= CGPointMake(screen.size.width-15, 15);
	[self.view addSubview:infoButton];
}

#pragma mark UI refresh

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([self.engine isRunning]) {
		// Setup timer to refresh counting UI Elements
		[self.engine pingEvery:cTimeRefreshRate target:self selector:@selector(updateActiveElements:) identifier:cTimerMainView];
	}
	
    [self updateUIElements];
	[tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	if ([self.engine isRunning]) {
		[self.engine stopPinging:cTimerMainView];
	}
}

- (void)updateActiveElements:(NSTimer *)theTimer {
	// Active table cell
	WTIntervalCell *cell= (WTIntervalCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	NSMutableDictionary *activity= [[WTDataModel sharedDataModel].activities objectAtIndex:0];
	cell.lastText= [WTUtil formattedTimeInterval:[model timeIntervalForActivity:activity] decimal:YES];
	
	// Table header
	NSMutableArray *sectionArray= [tableModel activitiesForMostRecentDay];
	tableHeader.lastText= [WTUtil formattedTotalTimeForIntervals:sectionArray withActive:YES];
}

- (void)updateUIElements {
	// Uncomment below to create Default.png
	//	statusLabel.text= @"Loading";
	//	startTimeLabel= @"";
	//	stopTimeLabel= @"";
	//	
	//	startButton.enabled= NO;
	//	stopButton.enabled= NO;
	
	[self updateLabels];	
	[self updateButtons];
}

- (void)updateLabels {
	statusLabel.text= [engine formattedStatus];
	NSMutableDictionary *interval= nil;
	if ([model.activities count] > 0) interval= [model.activities objectAtIndex:0];
	startTimeLabel.text= [WTUtil formattedStartTimeForActivity:interval];
	stopTimeLabel.text= [WTUtil formattedStopTimeForActivity:interval];	
}

- (void)updateButtons {
	if ([self.engine isRunning]) {
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
}

#pragma mark Handle buttons

- (void)start {
	if (!startTrackingController) {
		startTrackingController= [[WTStartTrackingRootController alloc] init];
		startTrackingController.superController= self;
	}
	
	// projectPicker lets the user select a proj. which is then send to the model
	[self presentModalViewController:startTrackingController animated:YES];
	
	// Now we wait until a project gets picked
}

- (void)userPickedProjectAtIndex:(NSUInteger)index comment:(NSString *)comment{
	[self dismissModalViewControllerAnimated:YES];
	
	if (index >= 0) {
		[self.engine startTrackingProject:[[model.projects allKeys] objectAtIndex:index] withComment:comment];
		
		[self updateUIElements];
				
		[tableView beginUpdates];
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
		if ([tableView numberOfRowsInSection:1] > 0) {
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationTop];
		}
		[tableView endUpdates];
		
		[self.engine pingEvery:cTimeRefreshRate target:self selector:@selector(updateActiveElements:) identifier:cTimerMainView];
	}
}

- (void)userCanceledProjectPicker {
	// Dismiss the picker and do nothing
	[self dismissModalViewControllerAnimated:YES];
}

- (void)stop {
	[self.engine stopTracking];
	[self.engine stopPinging:cTimerMainView];
	
	[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
	[self updateUIElements];
	[self updateActiveElements:nil];
}

- (void)displayInfoPage {
	if (!infoPage) {
		infoPage= [[WTInfo alloc] init];
		infoPage.superController= self;
		infoPage.modalTransitionStyle= UIModalTransitionStyleFlipHorizontal;
	}
	[self presentModalViewController:infoPage animated:YES];
}

#pragma mark UITableView delegate / dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tV {
	// One is for some fake cells
	return 2;
}

- (NSInteger)tableView:(UITableView *)tV numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows= [[tableModel activitiesForMostRecentDay] count];
	
	if (section == 0) {
		return numberOfRows;
	} else {
		return MAX(0, 4 - numberOfRows);
	}
}

- (UITableViewCell *)tableView:(UITableView *)tV cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID= @"ABCell";
	
	WTIntervalCell *cell= (WTIntervalCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
	if(cell == nil) {
		cell= [[[WTIntervalCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	
	if (indexPath.section == 0) {
		NSMutableDictionary *interval= [[tableModel activitiesForMostRecentDay] objectAtIndex:indexPath.row];
		BOOL running= NO;
		if (indexPath.row == 0 && [engine isRunning]) running= YES; // Display the green bubble to indicate that the project is being tracked
		cell.firstText= [WTUtil formattedProjectNameForActivity:interval running:running];
		cell.lastText= [WTUtil formattedTimeInterval:[model timeIntervalForActivity:interval] decimal:YES];
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
	}
	
	if ([model.activities count] > 0) {
		NSDate *mostRecentDate= [[model.activities objectAtIndex:0] objectForKey:cStartTime];
		tableHeader.firstText= [WTUtil dayForDate:mostRecentDate];
		
		NSMutableArray *sectionArray= [tableModel activitiesForMostRecentDay];
		tableHeader.lastText= [WTUtil formattedTotalTimeForIntervals:sectionArray withActive:YES];
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
	[infoButton release];
	[infoPage release];
	[startTrackingController release];
	[self.model release];
	[self.engine release];
	
	[super dealloc];
}

@end

