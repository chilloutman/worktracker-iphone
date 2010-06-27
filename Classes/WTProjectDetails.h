//
//  WTProjectDetails.h
//  WorkTracker
//
//  Created by Lucas Neiva on 02.10.09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTProjects;

@interface WTProjectDetails : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UITableView *tableView;
	NSArray *activities;
	
	NSMutableDictionary *project;
	NSString *projectName;
}

@property (nonatomic, retain) NSArray *activities;

- (id)initWithProject:(NSMutableDictionary *)pProject name:(NSString *)projectName activities:(NSArray *)activities;

@end
