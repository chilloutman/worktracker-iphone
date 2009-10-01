//
//  WTUtil.m
//  WorkTracker
//
//  Created by Lucas Neiva on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTUtil.h"

#import "WTConstants.h"
#import "WTDataModel.h"
#import "WTEngine.h"

@implementation WTUtil

#pragma mark Generic

+ (NSString *)dayForDate:(NSDate *)pDate {	
	NSCalendar *cal= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dC= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	NSDateComponents *pDateComps= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:pDate];
	
	if (pDateComps.year == dC.year && pDateComps.month == dC.month && pDateComps.day == dC.day) {
		return NSLocalizedString(@"Today", @"");
	}
	
	[date addTimeInterval:-86400];
	dC= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	if (pDateComps.year == dC.year && pDateComps.month == dC.month && pDateComps.day == dC.day) {
		return NSLocalizedString(@"Yesterday", @"");
	}
	
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	return [formatter stringFromDate:pDate];
}

+ (NSString *)weekForDate:(NSDate *)pDate {
	NSCalendar *cal= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps= [cal components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:date];
	NSDateComponents *pDateComps= [cal components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:pDate];

	
	if ((pDateComps.year == dateComps.year) && (pDateComps.week == dateComps.week)) {
		return NSLocalizedString(@"This Week", @"");
	}

	[date addTimeInterval:-604800];
	dateComps= [cal components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	if ((pDateComps.year == dateComps.year) && (pDateComps.week == dateComps.week)) {
		return NSLocalizedString(@"Last Week", @"");
	}
	
	NSString *weekString= [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Week", @""), pDateComps.week];
	
	return weekString;
}

+ (NSString *)monthForDate:(NSDate *)pDate {
	NSCalendar *cal= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps= [cal components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	NSDateComponents *pDateComps= [cal components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:pDate];
	
	
	if ((pDateComps.year == dateComps.year) && (pDateComps.month == dateComps.month)) {
		return NSLocalizedString(@"This Month", @"");
	}
	
	if (--dateComps.month == 0) {
		dateComps.month= 12;
		dateComps.year--;
	}
	
	if ((pDateComps.year == dateComps.year) && (pDateComps.month == dateComps.month)) {
		return NSLocalizedString(@"Last Month", @"");
	}
	
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMMM yyyy"];
	
	return [formatter stringFromDate:pDate];
}

#pragma mark Status & project name

+ (NSString *)formattedStatus {
	WTDataModel *model= [WTDataModel sharedDataModel];
	WTEngine *engine=  [WTEngine sharedEngine];
	
	if ([engine running] && [model.trackingIntervals count] > 0) {
		return [NSString stringWithFormat:NSLocalizedString(@"Tracking '%@'", @"Status, Currently tracking 'a project'"), [[model.trackingIntervals objectAtIndex:0] objectForKey:cProject]];
	} else if ([model.projects count] == 0) {
		return NSLocalizedString(@"There are no projects...", @"Status, Inform the user that the are no projects");
	} else {
		// return [NSString stringWithFormat:@"Standby %@", cCharSleeping];
		return NSLocalizedString(@"Standby", @"Status, Ready and waiting");
	}
}

+ (NSString *)formattedProjectNameForTrackingInterval:(NSMutableDictionary *)pInterval {
	WTDataModel *model= [WTDataModel sharedDataModel];
	WTEngine *engine=  [WTEngine sharedEngine];
	
	if (pInterval == nil) {
		return nil;
	}
	
	if ([engine running] && pInterval == [model.trackingIntervals objectAtIndex:0]) {
		// Display a green circle to indicate that the project is currently being tracked
		return [NSString stringWithFormat:@"%@ %@", cCharCircleGreen, [pInterval objectForKey:cProject]];
	} else {
		return [pInterval objectForKey:cProject];
	}
}

#pragma mark TrackingItervals

+ (NSString *)totalTimeForSection:(NSMutableArray *)section withActive:(BOOL)active {
	NSTimeInterval total= 0;
	
	for (NSMutableDictionary *trackingIterval in section) {
		total+= [[trackingIterval objectForKey:cTimeInterval] doubleValue];
	}
	
	if (!active && section == 0) {
		// Don't count the Interval that is still running
	}
	
	if (total > 0) {
		return [NSString stringWithFormat:@"%.2f h", total / 3600];
	} else {
		return nil;
	}
}

+ (NSString *)formattedTimeIntervalForTrackingInterval:(NSMutableDictionary *)pInterval decimal:(BOOL)decimal  {
	WTDataModel *model= [WTDataModel sharedDataModel];
	
	if (pInterval == nil) {
		if ([model.trackingIntervals count] > 0) pInterval= [model.trackingIntervals objectAtIndex:0];
		else return nil;
	}
	
	// Format timeInterval
	if (decimal) {
		double hours= [model timeIntervalForTrackingInterval:pInterval] / 3600;
		return [NSString stringWithFormat:@"%.3lf h", hours];
	} else {
		return @"This was not yet implemented";
	}
}

+ (NSString *)formattedStartTimeForTrackingInterval: (NSMutableDictionary *)pInterval {	
	WTDataModel *model= [WTDataModel sharedDataModel];
	WTEngine *engine= [WTEngine sharedEngine];
	
	// Use the newest intervall if parameter is nil
	if (pInterval == nil && [model.trackingIntervals count] > 0) {
		pInterval= [model.trackingIntervals objectAtIndex:0];
	}
	if (![engine running]) {
		return @"-";
	}
	
	NSDate *startDate= [pInterval objectForKey:cStartTime];
	if (startDate == nil) return @"-";
	
	// Return formatted Time
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:startDate];
}

+ (NSString *)formattedStopTimeForTrackingInterval: (NSMutableDictionary *)pInterval {
	WTDataModel *model= [WTDataModel sharedDataModel];
	
	if (pInterval == nil && [model.trackingIntervals count] > 0) {
		pInterval= [model.trackingIntervals objectAtIndex:0];
	}
	
	NSDate *stopTime= [pInterval objectForKey:cStopTime];
	if (stopTime == nil) return @"-";
	
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:stopTime];
}

@end
