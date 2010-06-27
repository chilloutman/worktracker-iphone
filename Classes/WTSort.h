//
//  WTHistoryTableViewModel.h
//  WorkTracker
//
//  Created by Lucas Neiva on 27.07.09.
//  ***
//

#import <Foundation/Foundation.h>
#import "WTConstants.h"

@class WTDataModel;
@class WTEngine;

// This class is an extention to WTDataModel that provides tableViews with data about the sections.
// It sorts the activities into segments based on the days, weeks or months they were tracked.

// This class has custom getters which return values based on the provided WTSortingType property.
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
- (NSMutableArray *)activitiesForMostRecentDay;

@end

