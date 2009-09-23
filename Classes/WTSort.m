//
//  WTHistoryTableViewModel.m
//  WorkTracker
//
//  Created by Lucas Neiva on 27.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTSort.h"

#import "WTDataModel.h"
#import "WTEngine.h"
#import "WTUtil.h"

static WTSort *sharedInstace= nil;

@implementation WTSort

+ (WTSort *)sharedSortingModel {
	@synchronized(self) {
		if (sharedInstace == nil) {
			sharedInstace= [[self alloc] init];
		}
	}
	return sharedInstace;
}

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
		engine= [WTEngine sharedEngine];
	}
	return self;
}

#pragma mark Generic methods for tableView building

- (NSMutableArray *)headerTitlesForSortingType:(WTSortingType)sortingType {	
	if (sortingType == WTSortingByDay) {
		// Days
		return dayTitles;
	} else if (sortingType == WTSortingByWeek) {
		// weeks
		return weekTitles;
	} else if (sortingType == WTSortingByMonth) {
		// months
		return nil;
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsForSortingType:(WTSortingType)sortingType {
	NSInteger numberOfSections= 0;
	
	if (sortingType  == WTSortingByDay) {
		numberOfSections= [dayTitles count];
	} else if (sortingType == WTSortingByWeek) {
		numberOfSections= [weekTitles count];
	} else if (sortingType == WTSortingByMonth) {
		// Months
	}
	
	return numberOfSections;
}

- (NSInteger)numberOfIntervalsForSection:(NSInteger)section withSortingType:(WTSortingType)sortingType {
	NSInteger numberOfIntervals= 0;
	
	if (sortingType == WTSortingByDay) {
		numberOfIntervals= [self numberOfIntervalsForDay:section withActive:NO];
	} else if (sortingType == WTSortingByWeek) {
		numberOfIntervals= [self numberOfIntervalsForWeek:section];
	} else if (sortingType == WTSortingByMonth) {
		// Months
	}
	
	return numberOfIntervals;
}

- (void)setupSections:(WTSortingType)sortingType {	
	if (sortingType == WTSortingByDay && !dayTitles) {
		[self setupDays];
	} else if (sortingType == WTSortingByWeek) {
		[self setupWeeks];
	} else if (sortingType == WTSortingByMonth) {
		// Months
	}
}

#pragma mark Days

- (void)setupDays {
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComponents= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date]; // Today at 00:00, reference
	
	NSInteger dayID= 0; // 0= today, 1= yesterday, ..., 5= rest
	if (!dayTitles) dayTitles= [[NSMutableArray alloc] initWithCapacity:6];
	int i; // loop counter
	NSDate *curDate; // loops through the startDates
	NSDateComponents *curDateComponents; // components of curDate
	
	int lastDayID= -1;
	
	for (i= 0; i < [model.trackingIntervals count]; i++) {
		curDate= [[model.trackingIntervals objectAtIndex:i] objectForKey:cStartTime];
		curDateComponents= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:curDate];
		
		// if (curDate != date)
		if ((curDateComponents.year != dateComponents.year) || (curDateComponents.month != dateComponents.month) || (curDateComponents.day != dateComponents.day)) {
			// Decrease day by 1
			date= [date addTimeInterval:-(60*60*24)]; // day--;
			dateComponents= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date];
			
			// Increase dayID by 1, dayID maches tableView section <- I'm not so sure about this one anymore...
			dayID++;
			
			if (dayID == 5)  {
				// Everything older than 5 days gets into 'Older'
				break;
			}
		}
		
		// Check if curDate is on the same day the current reference (dayComponents)
		if ((curDateComponents.year == dateComponents.year) && (curDateComponents.month == dateComponents.month) && (curDateComponents.day == dateComponents.day)) {
			// Set dayID
			[[model.trackingIntervals objectAtIndex:i] setObject:[NSNumber numberWithInteger:dayID] forKey:cDayID];
			// Set title for dayID, no duplicates
			if (dayID != lastDayID) {
				[dayTitles addObject:[WTUtil dayForDate:curDate]];
				lastDayID= dayID;
			}
		} else {
			// Run the loop once again with the same object
			i--;
		}
	}
	
	// The rest
	while (i < [model.trackingIntervals count]) {
		if (lastDayID != 5) {
			[dayTitles addObject:NSLocalizedString(@"Older than a week", @"")]; // This gets added every time... major bug
			lastDayID= 5;
		}
		
		NSMutableDictionary *curInterval= [model.trackingIntervals objectAtIndex:i];
		
		// Break because if the current elements dayID is 5, all the older ones must be 5 too
		if ([[curInterval objectForKey:cDayID] integerValue] == 5) break;
		
		[curInterval setObject:[NSNumber numberWithInteger:5] forKey:cDayID];
		i++;
	}
	
	// Save data
	[model didChangeCollection:cTrackingIntervals];
	
	[calendar release];
}

- (NSInteger)numberOfIntervalsForDay:(NSInteger)dayID withActive:(BOOL)active {
	// TODO: Save this Values to iVar for more performance? Caution!: I have to make sure they stay up to date
	
	NSInteger numberOfIntervals= 0;
	
	// Count
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		NSInteger curDayID= [[trackingInterval objectForKey:cDayID] integerValue];
		
		if (curDayID == dayID) {
			numberOfIntervals++;
		} else if (curDayID > dayID) {
			break;
		}
	}
	
	// Caller doesn't want a running interval to be counted
	if (!active && [engine running] && (dayID == 0)) numberOfIntervals--;
	
	return numberOfIntervals;
}

#pragma mark Weeks

- (void)setupWeeks {
	// Idea: Every week gets an ID, The most recent one is 0
	// I have to limit this, because I currently have no solutin that allows me to correcly implement weekIDs for more than a year
	
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComponents= [calendar components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	NSInteger weekID= 0;
	NSDate *curDate;
	NSDateComponents *curDateComponents;
	int i;
	int trackingsCount= [model.trackingIntervals count];
	int lastWeekID= -1;
	
	for (i= 0; i < trackingsCount; i++) {
		curDate= [[model.trackingIntervals objectAtIndex:i] objectForKey:cStartTime];
		curDateComponents= [calendar components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:curDate];
		
		if ((curDateComponents.year == dateComponents.year) && (curDateComponents.week == dateComponents.week)) {
			// Set weekID
			[[model.trackingIntervals objectAtIndex:i] setObject:[NSNumber numberWithInteger:weekID] forKey:cWeekID];
			// Set title for weekID, no duplicates
			if (weekID != lastWeekID) {
				[weekTitles addObject:[WTUtil weekForDate:curDate]];
				lastWeekID= weekID;
			}
		} else {
			// Decrease week by 1
			date= [date addTimeInterval:-(60*60*24*7)]; // Minus one week
			dateComponents= [calendar components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:date];
			
			// Increase weekID by 1, weekID maches tableView section
			weekID++;
			
			if (weekID == 5)  {
				// Everything older than 5 days gets into 'Older'
				break;
			}
			
			// Run the loop once again with the same object
			i--;
		}
	}
	
	// The rest
	while (i < [model.trackingIntervals count]) {
		if (lastWeekID != 5) {
			[weekTitles addObject:NSLocalizedString(@"Older than a month", @"")];
			lastWeekID= 5;
		}
		
		NSMutableDictionary *curInterval= [model.trackingIntervals objectAtIndex:i];
		
		// Break because if the current elements dayID is 5, all the older ones must be 5 too
		if ([[curInterval objectForKey:cDayID] integerValue] == 5) break;
		
		[curInterval setObject:[NSNumber numberWithInteger:5] forKey:cDayID];
		i++;
	}
	
	// Save data
	[model didChangeCollection:cTrackingIntervals];
	
	[calendar release];
}

- (NSInteger)numberOfIntervalsForWeek:(NSInteger)section {
	return 0;
}

#pragma mark -

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)retain {
    return sharedInstace;
}

- (id)autorelease {
    return sharedInstace;
}

@end
