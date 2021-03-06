//
//  WTUtil.m
//  WorkTracker
//
//  Created by Lucas Neiva on 28.07.09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import "WTUtil.h"

#import "WTConstants.h"
#import "WTEngine.h"
#import "WTDataModel.h"

@implementation WTUtil

#pragma mark Generic

+ (NSString *)dayForDate:(NSDate *)pDate {	
	NSCalendar *cal= [self calendar];
	NSDate *date= [NSDate date];
	NSDateComponents *dC= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	NSDateComponents *pDateComps= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:pDate];
	
	if (pDateComps.year == dC.year && pDateComps.month == dC.month && pDateComps.day == dC.day) {
		return NSLocalizedString(@"Today", @"");
	}
	
	date= [date dateByAddingTimeInterval:-86400];
	dC= [cal components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	if (pDateComps.year == dC.year && pDateComps.month == dC.month && pDateComps.day == dC.day) {
		return NSLocalizedString(@"Yesterday", @"");
	}
	
	return [self shortDateForDate:pDate];
}

+ (NSString *)weekForDate:(NSDate *)pDate {
	NSCalendar *cal= [self calendar];
	NSDate *date= [NSDate date];
	NSDateComponents *dateComps= [cal components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:date];
	NSDateComponents *pDateComps= [cal components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:pDate];

	
	if ((pDateComps.year == dateComps.year) && (pDateComps.week == dateComps.week)) {
		return NSLocalizedString(@"This Week", @"");
	}

	date= [date dateByAddingTimeInterval:-604800];
	dateComps= [cal components:NSWeekCalendarUnit | NSYearCalendarUnit fromDate:date];
	
	if ((pDateComps.year == dateComps.year) && (pDateComps.week == dateComps.week)) {
		return NSLocalizedString(@"Last Week", @"");
	}
	
	NSString *weekString= [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Week", @""), pDateComps.week];
	
	return weekString;
}

+ (NSString *)monthForDate:(NSDate *)pDate {
	NSCalendar *cal= [self calendar];
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
	
	NSDateFormatter *formatter= [self dateFormatter];
	[formatter setDateFormat:@"MMMM yyyy"];
	
	return [formatter stringFromDate:pDate];
}

+ (NSString *)timeForDate:(NSDate *)pDate {
	NSDateFormatter *formatter= [self timeFormatter];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:pDate];
}

+ (NSString *)dateForDate:(NSDate *)pDate {
	NSDateFormatter *formatter= [self dateFormatter];
	[formatter setDateStyle:NSDateFormatterFullStyle];
	
	return [formatter stringFromDate:pDate];
}

+ (NSString *)shortDateForDate:(NSDate *)pDate {
	NSDateFormatter *formatter= [self dateFormatter];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	return [formatter stringFromDate:pDate];
}

+ (NSString *)formattedTimeInterval:(NSTimeInterval)interval decimal:(BOOL)decimal  {
	NSString *timeString= nil;
	
	if (decimal) {
		double hours= interval / 3600;
		timeString= [NSString stringWithFormat:@"%.3lf h", hours];
	} else {
		int minutes= (int) interval / 60;
		if (minutes > 59) {
			int hours= (minutes - (minutes % 60)) / 60;
			minutes= minutes % 60;
			if (hours > 23) {
				int days= (hours - (hours % 24)) / 24;
				hours= hours % 24;
				if (days > 6) {
					int weeks= (days - (days % 7) / 7);
					days= days % 7;
					timeString= [NSString stringWithFormat:@"%d w %d d %d h %d m", weeks, days, hours, minutes];
				} else timeString= [NSString stringWithFormat:@"%d d %d h %d m", days, hours, minutes];
			} else timeString= [NSString stringWithFormat:@"%d h %d m", hours, minutes];
		} else timeString= [NSString stringWithFormat:@"%d m", minutes];
	}
	
	return timeString;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
	CGSize size= CGSizeMake(25, 25);
	
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx= UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(ctx);{
		[color setFill];
		CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
	} UIGraphicsPopContext();
	
	UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();	
	return image;
}

#pragma mark Status & project name

+ (NSString *)formattedProjectNameForActivity:(NSMutableDictionary *)pInterval running:(BOOL)running {
	if (pInterval == nil) return nil;
	
	if (running) {
		// Display a green circle to indicate that the project is currently being tracked
		return [NSString stringWithFormat:@"%@ %@", cCharCircleGreen, [pInterval objectForKey:cProject]];
	} else {
		return [pInterval objectForKey:cProject];
	}
}

#pragma mark TrackingItervals

+ (NSTimeInterval)totalTimeForIntervals:(NSArray *)intervals {
	NSTimeInterval total= 0;
	
	//if (!active && section == 0) {
		// TODO: don't count the Interval that is still running
	
	for (NSMutableDictionary *trackingIterval in intervals) {
//		total+= [[trackingIterval objectForKey:cTimeInterval] doubleValue];
		total+= [[WTDataModel sharedDataModel] timeIntervalForActivity:trackingIterval];
	}
	
	return total;
}

+ (NSString *)formattedTotalTimeForIntervals:(NSArray *)intervals withActive:(BOOL)active {
	NSTimeInterval total= [self totalTimeForIntervals:intervals];
	
	if (total > 0) {
		return [NSString stringWithFormat:@"%.2f h", total / 3600];
	} else {
		return nil;
	}
}

+ (NSString *)formattedStartTimeForActivity:(NSMutableDictionary *)pInterval {		
	if (pInterval == nil) return nil;
	if (![[WTEngine sharedEngine] isRunning]) {
		return @"-";
	}
	
	NSDate *startDate= [pInterval objectForKey:cStartTime];
	if (startDate == nil) return @"-";
	
	// Return formatted Time
	NSDateFormatter *formatter= [self timeFormatter];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:startDate];
}

+ (NSString *)formattedStopTimeForActivity:(NSMutableDictionary *)pInterval {
	if (pInterval == nil) return nil;
	
	NSDate *stopTime= [pInterval objectForKey:cStopTime];
	if (stopTime == nil) return @"-";
	
	NSDateFormatter *formatter= [self timeFormatter];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	
	return [formatter stringFromDate:stopTime];
}

#pragma mark Caches

+ (NSDateFormatter *)dateFormatter {
	static NSDateFormatter *formatter= nil;
	if (!formatter){
		formatter= [[NSDateFormatter alloc] init];
	}
	return formatter;
}

+ (NSDateFormatter *)timeFormatter {
	static NSDateFormatter *formatter= nil;
	if (!formatter){
		formatter= [[NSDateFormatter alloc] init];
	}
	return formatter;
}

+ (NSCalendar *)calendar {
	static NSCalendar *calendar= nil;
	if (!calendar) {
		calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	}
	return calendar;
}

@end
