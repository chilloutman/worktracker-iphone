//
//  WTUtil.m
//  WorkTracker
//
//  Created by Lucas Neiva on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTUtil.h"

@implementation WTUtil

+ (NSString *)dayForDate:(NSDate *)pDate {
	NSCalendar *cal= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	
	NSDate *date= [NSDate date];
	NSDateComponents *dateComponents= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	// pDate
	NSDateComponents *pDateComponents= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:pDate];
	
	// Today or Yesterday?
	if ((pDateComponents.year == dateComponents.year) && (pDateComponents.month == dateComponents.month) && (pDateComponents.day == dateComponents.day)) {
		return NSLocalizedString(@"Today", @"");
	}
	[date addTimeInterval:-(60*60*24)];
	pDateComponents= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	if ((pDateComponents.year == dateComponents.year) && (pDateComponents.month == dateComponents.month) && (pDateComponents.day == dateComponents.day)) {
		return NSLocalizedString(@"Yesterday", @"");
	}
	
	// Not Today or Yesterday:
	NSDateFormatter *formatter= [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"EEEE"]; // Weekday name
	
	return [formatter stringFromDate:pDate];
}

+ (NSString *)weekForDate:(NSDate *)pDate {
	NSCalendar *cal= [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *dateComponents= [cal components:NSWeekCalendarUnit fromDate:pDate];
	
	NSString *weekString= [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Week", @""), dateComponents.week];
	
	// TODO: Starting on...
	
	return weekString;
}

@end
