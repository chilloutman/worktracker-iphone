//
//  WTHistoryTableViewModel.h
//  WorkTracker
//
//  Created by Lucas Neiva on 27.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTConstants.h"

@class WTDataModel;
@class WTEngine;

// This class is like an extention to WTDataModel that provides tableViews with data about the sections.
// It also sorts the trackingIntervals into segments based on the days, weeks or months they were tracked.

// This class has a lot of custom getters which return values based on the provided WTSortingType property.
// (WTSortingType is a custom enum and is declared inside WTConstants.h)

@interface WTSort : NSObject {
	WTDataModel *model;
	WTEngine *engine;
	
	BOOL daySectionsAreUpToDate;
	BOOL weekSectionsAreUpToDate;
	BOOL monthSectionsAreUpToDate;
	
	NSMutableArray *daySections;
	NSMutableArray *weekSections;
	NSMutableArray *monthSections;
	
	NSMutableArray *dayTitles;
	NSMutableArray *weekTitles;
	NSMutableArray *monthTitles;	
}

+ (WTSort *)sharedSortingModel;

- (void)invalidateSectionsForSortingType:(WTSortingType)sortingType;

- (NSMutableArray *)sectionArrayForSortingType:(WTSortingType)sortingType;
- (NSMutableArray *)headerTitlesForSortingType:(WTSortingType)sortingType;
- (NSMutableArray *)trackingIntervalsForMostRecentDay;

#pragma mark Private

// Methods which create the section and title arrays
- (void)setupDays;
- (void)setupWeeks;
- (void)setupMonths;

@end
