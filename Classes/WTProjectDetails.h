//
//  WTProjectDetails.h
//  WorkTracker
//
//  Created by Lucas Neiva on 02.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTProjects;

@interface WTProjectDetails : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UITableView *tableView;
	NSArray *trackingIntervals;
	
	NSMutableDictionary *project;
}

@property (nonatomic, retain) NSArray *trackingIntervals;

- (id)initWithProject:(NSMutableDictionary *)pProject name:(NSString *)projectName trackingIntervals:(NSArray *)pTrackingIntervals;

@end
