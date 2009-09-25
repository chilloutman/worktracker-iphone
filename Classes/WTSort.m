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

@synthesize sectionsAreUpToDate;

- (id)init {
	if (self= [super init]) {
		model= [WTDataModel sharedDataModel];
		engine= [WTEngine sharedEngine];
		self.sectionsAreUpToDate= NO;
	}
	return self;
}

#pragma mark Getters for tableView building

- (NSMutableArray *)trackingIntervalsForMostRecentDay {
	//if (!self.sectionsAreUpToDate) [self setupDays];
	
	[self setupDays];
	
	if (daySections) {
		if ([daySections count] > 0) return [daySections objectAtIndex:0];
	}
	
	return nil;
}

- (NSMutableArray *)headerTitlesForSortingType:(WTSortingType)sortingType {	
	if (sortingType == WTSortingByDay) {
		if (!sectionsAreUpToDate) {
			[self setupDays];
		}
		return dayTitles;
	} else if (sortingType == WTSortingByWeek) {
		if (!sectionsAreUpToDate) {
			[self setupWeeks];
		}
		return weekTitles;
	} else if (sortingType == WTSortingByMonth) {
		return nil;
	} else {
		return nil;
	}
}

- (NSMutableArray *)sectionArrayForSortingType:(WTSortingType)sortingType {
	if (sortingType == WTSortingByDay) {
		if (!sectionsAreUpToDate) {
			[self setupDays];
		}
		return daySections;
	} else if (sortingType == WTSortingByWeek) {
		return weekSections;
	} else if (sortingType == WTSortingByMonth) {
		return nil;
	} else {
		return nil;
	}
}

#pragma mark Days

- (void)setupDays {
	NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
	
	// These are the arrays this method is going to fill / renew
	// TODO: A Standard C array would much faster and easier to read from (array[section][row])
	[daySections release];
	[dayTitles release];
	daySections= [[NSMutableArray alloc] init];
	dayTitles= [[NSMutableArray alloc] init];
	
	NSCalendar *calendar= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComponents;
	
	NSMutableArray *curArray= [NSMutableArray array]; // Every Section is represented by an array
	NSDate *curDate; // Loops through the startDates
	NSDateComponents *curDateComponents; // Components of curDate
	NSDate *lastDate;
	
	for (NSMutableDictionary *trackingInterval in model.trackingIntervals) {
		curDate= [trackingInterval objectForKey:cStartTime];
		curDateComponents= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:curDate];
		dateComponents= [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
		
		// Check if curDate is on the same day the current reference (dateComponents)
		if ((curDateComponents.year == dateComponents.year) && (curDateComponents.month == dateComponents.month) && (curDateComponents.day == dateComponents.day)) {
			// Add to current array
			[curArray addObject:trackingInterval];
		} else {
			if ([curArray count] > 0) {
				NSLog(@"Finalized a section: %@", curArray);
				// Add a title for the section
				[dayTitles addObject:[WTUtil dayForDate:lastDate]];
				// Add current array as a section
				[daySections addObject:curArray];
				// Create a new current array
				curArray= [NSMutableArray array];
			}
			// Set the date that maches
			date= [trackingInterval objectForKey:cStartTime];
			dateComponents= [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:date];
			
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
	
	self.sectionsAreUpToDate= YES;
	[pool drain];
}

#pragma mark Weeks

- (void)setupWeeks {

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
    return sharedSortingModel;
}

- (id)autorelease {
    return sharedSortingModel;
}

@end
