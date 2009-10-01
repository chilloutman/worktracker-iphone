//
//  WTTrackingIntervals.h
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTConstants.h"

@class WTDataModel, WTEngine, WTSort, WTHistoryViewController;

@interface WTTrackingIntervals : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	UITableView *tableView;
	WTSortingType activeSortingType;
	WTHistoryViewController *superController;
	
	WTDataModel *model;
	WTSort *tableModel;
	WTEngine *engine;
}

@property (nonatomic, retain) WTHistoryViewController *superController;

@end
