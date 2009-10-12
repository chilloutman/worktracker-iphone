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
		[self invalidateSectionsForSortingType:WTSortingAll];
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
		case WTSortingAll:
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
	[daySections release];
	[dayTitles release];
	daySections= [[NSMutableArray alloc] init];
	dayTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [WTUtil calendar];
	
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps;
	NSDate *curDate; // Loops through the startDates
	NSDateComponents *curDateComps; // Components of curDate
	NSDate *lastDate= nil;
	
	NSMutableArray *curArray= [NSMutableArray array]; // Every Section is represented by an array
	
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
	
	[pool release];
}

- (void)setupWeeks {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	
	[weekSections release];
	[weekTitles release];
	weekSections= [[NSMutableArray alloc] init];
	weekTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [WTUtil calendar];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps;
	
	NSMutableArray *curArray= [NSMutableArray array];
	NSDate *curDate;
	NSDateComponents *curDateComps;
	NSDate *lastDate= nil;
	
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		curDate= [trackingInterval objectForKey:cStartTime];
		curDateComps= [calendar components:NSYearCalendarUnit | NSWeekCalendarUnit fromDate:curDate];
		dateComps= [calendar components: NSYearCalendarUnit | NSWeekCalendarUnit fromDate:date];
		
		if ((curDateComps.year == dateComps.year) && (curDateComps.week == dateComps.week)) {
			[curArray addObject:trackingInterval];
		} else {
			if ([curArray count] > 0) {
				[weekTitles addObject:[WTUtil weekForDate:lastDate]];
				[weekSections addObject:curArray];
				curArray= [NSMutableArray array];
			}
			date= [trackingInterval objectForKey:cStartTime];
			
			[curArray addObject:trackingInterval];
		}
		lastDate= curDate;
	}
	
	if ([curArray count] > 0) {
		[weekTitles addObject:[WTUtil weekForDate:lastDate]];
		[weekSections addObject:curArray];
	}
	
	weekSectionsAreUpToDate= YES;
	[pool drain];
}

- (void)setupMonths {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	
	[monthSections release];
	[monthTitles release];
	monthSections= [[NSMutableArray alloc] init];
	monthTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [WTUtil calendar];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps;
	
	NSMutableArray *curArray= [NSMutableArray array];
	NSDate *curDate;
	NSDateComponents *curDateComps;
	NSDate *lastDate= nil;
	
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		curDate= [trackingInterval objectForKey:cStartTime];
		curDateComps= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:curDate];
		dateComps= [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
		
		if ((curDateComps.year == dateComps.year) && (curDateComps.month == dateComps.month)) {
			[curArray addObject:trackingInterval];
		} else {
			if ([curArray count] > 0) {
				[monthTitles addObject:[WTUtil monthForDate:lastDate]];
				[monthSections addObject:curArray];
				curArray= [NSMutableArray array];
			}
			date= [trackingInterval objectForKey:cStartTime];
			
			[curArray addObject:trackingInterval];
		}
		lastDate= curDate;
	}
	
	if ([curArray count] > 0) {
		[monthTitles addObject:[WTUtil monthForDate:lastDate]];
		[monthSections addObject:curArray];
	}
	
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