//
//  WTMainViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTDataModel, WTSort, WTEngine, WTStartTrackingRootController, WTInfo, WTTableSectionHeader;

@interface WTMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	UILabel *statusLabel;
	UIButton *startButton;
	UIButton *stopButton;
	UILabel *startTimeLabel;
	UILabel *stopTimeLabel;
	UIButton *infoButton;
	UITableView *tableView;
	WTTableSectionHeader *tableHeader;
	
	WTDataModel *model;
	WTSort *tableModel;
	WTEngine *engine;
	
	WTStartTrackingRootController *startTrackingController;
	WTInfo *infoPage;
}

@property (nonatomic, assign) WTDataModel *model;
@property (nonatomic, assign) WTEngine *engine;

- (void)userPickedProjectAtIndex:(NSUInteger)index comment:(NSString *)comment;
- (void)userCanceledProjectPicker;

#pragma mark Private

- (void)updateUIElements;

@end
