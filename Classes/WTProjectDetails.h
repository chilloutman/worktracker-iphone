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
	
	NSMutableDictionary *project;
	WTProjects *superController;
}

@property (nonatomic, retain) WTProjects *superController;

- (id)initWithProject:(NSMutableDictionary *)pProject projectName:(NSString *)projectName;

@end
