//
//  WTMainViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTDataModel, WTSort, WTEngine, WTProjectPicker, WTTableSectionHeader;

@interface WTMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UILabel *statusLabel;
	UIButton *startButton;
	UIButton *stopButton;
	UILabel *startTimeLabel;
	UILabel *stopTimeLabel;
	UITableView *tableView;
	NSInteger numberOfFakeCells;
	WTTableSectionHeader *tableHeader;
	
	WTDataModel *model;
	WTSort *tableModel;
	WTEngine *engine;
	
	WTProjectPicker *projectPicker;
}

@property (nonatomic, retain) WTDataModel *model;
@property (nonatomic, retain) WTEngine *engine;

- (void)userPickedProjectAtIndex: (NSInteger)index;
- (void)userCanceledProjectPicker;

#pragma mark Private

- (void)updateUIElements;

@end
