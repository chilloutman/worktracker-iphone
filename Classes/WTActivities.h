//
//  WTActivities.h
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  ***
//

#import <UIKit/UIKit.h>
#import "WTConstants.h"

@class WTDataModel, WTEngine, WTSort, WTOverviewRootController;

@interface WTActivities : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
	UITableView *tableView;
	UIBarButtonItem *deleteButton;
	WTSortingType activeSortingType;
	WTOverviewRootController *superController;
	
	WTDataModel *model;
	WTSort *tableModel;
	WTEngine *engine;
}

@property (nonatomic, retain) WTOverviewRootController *superController;
@property (nonatomic, assign) UITableView *tableView;

@end
