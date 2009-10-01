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

static WTSort *sharedSortingModel= nil;

@implementation WTSort

+ (WTSort *)sharedSortingModel {
	@synchronized(self) {
		if (sharedSortingModel == nil) {
			sharedSortingModel= [[self alloc] init];
		}
	}
	return sharedSortingModel;
}

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
		engine= [WTEngine sharedEngine];
		[self invalidateSectionsForSortingType:WTSortingByAll];
	}
	return self;
}

#pragma mark Caching switch

- (void)invalidateSectionsForSortingType:(WTSortingType)sortingType {
	// Thanks to this the expensive setup* methods get called less often
	
	switch (sortingType) {
		case WTSortingByDay:
			daySectionsAreUpToDate= NO;
			break;
		case WTSortingByWeek:
			weekSectionsAreUpToDate= NO;
			break;
		case WTSortingByMonth:
			monthSectionsAreUpToDate= NO;
			break;
		case WTSortingByAll:
			daySectionsAreUpToDate= NO;
			weekSectionsAreUpToDate= NO;
			monthSectionsAreUpToDate= NO;
			break;

	}
}

#pragma mark Getters for tableView building

- (NSMutableArray *)trackingIntervalsForMostRecentDay {
	if (!daySectionsAreUpToDate) [self setupDays];
		
	if ([daySections count] > 0) return [daySections objectAtIndex:0];
	
	return nil;
}

- (NSMutableArray *)headerTitlesForSortingType:(WTSortingType)sortingType {	
	switch (sortingType) {
		case WTSortingByDay:
			if (!daySectionsAreUpToDate) [self setupDays];
			return dayTitles;
		case WTSortingByWeek:
			if (!weekSectionsAreUpToDate) [self setupWeeks];
			return weekTitles;
		case WTSortingByMonth:
			if (!monthSectionsAreUpToDate) [self setupMonths];
			return monthTitles;
		default:
			return nil;
	}
}

- (NSMutableArray *)sectionArrayForSortingType:(WTSortingType)sortingType {
	switch (sortingType) {
		case WTSortingByDay:
			if (!daySectionsAreUpToDate) [self setupDays];
			return daySections;
		case WTSortingByWeek:
			if (!weekSectionsAreUpToDate) [self setupWeeks];
			return weekSections;
		case WTSortingByMonth:
			if (!monthSectionsAreUpToDate) [self setupMonths];
			return monthSections;
		default:
			return nil;
	}
}

#pragma mark Sorting

- (void)setupDays {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	
	// These are the arrays this method is going to fill / renew
	// TODO: A Standard C array would be easier to read from (array[section][row]) but harder to create (malloc)
	[daySections release];
	[dayTitles release];
	daySections= [[NSMutableArray alloc] init];
	dayTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps;
	
	NSMutableArray *curArray= [NSMutableArray array]; // Every Section is represented by an array
	NSDate *curDate; // Loops through the startDates
	NSDateComponents *curDateComps; // Components of curDate
	NSDate *lastDate;
	
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		curDate= [trackingInterval objectForKey:cStartTime];
		curDateComps= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:curDate];
		dateComps= [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
		
		// Check if curDate is on the same day the current reference (dateComponents)
		if ((curDateComps.year == dateComps.year) && (curDateComps.month == dateComps.month) && (curDateComps.day == dateComps.day)) {
			// Add to current array
			[curArray addObject:trackingInterval];
		} else {
			if ([curArray count] > 0) {
				// Add a title for the section
				[dayTitles addObject:[WTUtil dayForDate:lastDate]];
				// Add current array as a section
				[daySections addObject:curArray];
				// Create a new current array
				curArray= [NSMutableArray array];
			}
			// Set the date that maches
			date= [trackingInterval objectForKey:cStartTime];
			dateComps= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date];
			
			[curArray addObject:trackingInterval];
		}
		lastDate= curDate;
	}
	
	// Finalize the last section
	if ([curArray count] > 0) {
		// Add a title for the section
		[dayTitles addObject:[WTUtil dayForDate:lastDate]];
		// Add current array as a section
		[daySections addObject:curArray];
	}
	
	// Mark the Arrays as upToDate
	daySectionsAreUpToDate= YES;
	[pool drain];
}

- (void)setupWeeks {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	
	// These are the arrays this method is going to fill / renew
	[weekSections release];
	[weekTitles release];
	weekSections= [[NSMutableArray alloc] init];
	weekTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps;
	
	NSMutableArray *curArray= [NSMutableArray array]; // Every Section is represented by an array
	NSDate *curDate; // Loops through the startDates
	NSDateComponents *curDateComps; // Components of curDate
	NSDate *lastDate;
	
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		curDate= [trackingInterval objectForKey:cStartTime];
		curDateComps= [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit fromDate:curDate];
		dateComps= [calendar components: NSYearCalendarUnit | NSWeekCalendarUnit fromDate:date];
		
		// Check if curDate is on the same week the current reference (dateComps)
		if ((curDateComps.year == dateComps.year) && (curDateComps.week == dateComps.week)) {
			// Add to current array
			[curArray addObject:trackingInterval];
		} else {
			if ([curArray count] > 0) {
				// Add a title for the section
				[weekTitles addObject:[WTUtil weekForDate:lastDate]];
				// Add current array as a section
				[weekSections addObject:curArray];
				// Create a new current array
				curArray= [NSMutableArray array];
			}
			// Set the date that maches
			date= [trackingInterval objectForKey:cStartTime];
			dateComps= [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit fromDate:date];
			
			[curArray addObject:trackingInterval];
		}
		lastDate= curDate;
	}
	
	// Finalize the last section
	if ([curArray count] > 0) {
		// Add a title for the section
		[weekTitles addObject:[WTUtil weekForDate:lastDate]];
		// Add current array as a section
		[weekSections addObject:curArray];
	}
	
	// Mark the Arrays as upToDate
	weekSectionsAreUpToDate= YES;
	[pool drain];
}

- (void)setupMonths {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	
	// These are the arrays this method is going to fill / renew
	[monthSections release];
	[monthTitles release];
	monthSections= [[NSMutableArray alloc] init];
	monthTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps;
	
	NSMutableArray *curArray= [NSMutableArray array]; // Every Section is represented by an array
	NSDate *curDate; // Loops through the startDates
	NSDateComponents *curDateComps; // Components of curDate
	NSDate *lastDate;
	
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		curDate= [trackingInterval objectForKey:cStartTime];
		curDateComps= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:curDate];
		dateComps= [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
		
		// Check if curDate is on the same month the current reference (dateComps)
		if ((curDateComps.year == dateComps.year) && (curDateComps.month == dateComps.month)) {
			// Add to current array
			[curArray addObject:trackingInterval];
		} else {
			if ([curArray count] > 0) {
				// Add a title for the section
				[monthTitles addObject:[WTUtil monthForDate:lastDate]];
				// Add current array as a section
				[monthSections addObject:curArray];
				// Create a new current array
				curArray= [NSMutableArray array];
			}
			// Set the date that maches
			date= [trackingInterval objectForKey:cStartTime];
			dateComps= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
			
			[curArray addObject:trackingInterval];
		}
		lastDate= curDate;
	}
	
	// Finalize the last section
	if ([curArray count] > 0) {
		// Add a title for the section
		[monthTitles addObject:[WTUtil monthForDate:lastDate]];
		// Add current array as a section
		[monthSections addObject:curArray];
	}
	
	// Mark the Arrays as upToDate
	monthSectionsAreUpToDate= YES;
	[pool drain];
}

#pragma mark -

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)retain {
    return sharedSortingModel;
}

- (id)autorelease {
    return sharedSortingModel;
}

@end
