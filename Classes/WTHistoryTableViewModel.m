//
//  WTHistoryTableViewModel.m
//  WorkTracker
//
//  Created by Lucas Neiva on 27.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTHistoryTableViewModel.h"
#import "WTDataModel.h"


@implementation WTHistoryTableViewModel

@synthesize model;

- (id)init {
	self= [super init];
	return self;
}

- (NSMutableArray *)headerTitlesForSegment:(NSInteger)segement {	
	if (segement == 0) {
		// Days
		return self.model.dayTitles;
		/*
//		if (!daysHeaderTitles) {
//			daysHeaderTitles= [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Today", @""), NSLocalizedString(@"Yesterday", @""), nil];
//			
//			NSCalendar *cal= [NSCalendar currentCalendar];
//			NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
//			[formatter setDateFormat:@"EEEE"]; // Weekday name
//			NSDateComponents *dateComponets= [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
//			dateComponets.day-= 1;
//			for (int i= 2; i < 5; i++) {
//				dateComponets.day-=1;
//				NSDate *date= [cal dateFromComponents:dateComponets];
//				
//				[daysHeaderTitles addObject:[formatter stringFromDate:date]];
//			}
//			
//			[daysHeaderTitles addObject:NSLocalizedString(@"Older", @"Title for trackings that are older than some days old")];
//		}
//		return daysHeaderTitles;
//		
		 */
	} else if (segement == 1) {
		// weeks
		return nil;
	} else if (segement == 2) {
		// months
		return nil;
	}
	
	return nil;
}
- (NSInteger)numberOfSectionsForSegment:(NSInteger)segment {
	if (segment == 0) {
		return 0;
	} else if (segment == 1) {
		return 0;
	} else if (segment == 2) {
		return 0;
	}
	
	return 0;
}

- (void)dealloc {
	[model release];
	[super dealloc];
}

@end
