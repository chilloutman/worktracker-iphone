//
//  WTStatisticsViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTConstants.h"

@class WTDataModel, WTEngine, WTSort;

@interface WTHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>{
	UINavigationController *navController;
	UITableView *tableView;
	WTSortingType activeSortingType;
	
	WTDataModel *model;
	WTSort *tableModel;
	WTEngine *engine;
}

@property (nonatomic, assign) WTDataModel *model;
@property (nonatomic, assign) WTEngine *engine;

@end
