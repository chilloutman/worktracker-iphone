//
//  WTProjectAddViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 09.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTProjects;

@interface WTProjectAdd : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UIBarButtonItem *doneButton;
	UITableView * tableView;
	UITextField *nameField;
	UISegmentedControl *colorPicker;
	NSArray *colors;
	UIColor *projectColor;
	
	WTProjects *superController;
}

@property (nonatomic, retain) WTProjects *superController;

@end
