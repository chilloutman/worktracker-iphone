//
//  WTHistoryTableViewModel.h
//  WorkTracker
//
//  Created by Lucas Neiva on 27.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTDataModel;

// This class serves the History View Controller and it's tableView with data
// It's like a bridge between WTHistoryViewController and WTDataModel

@interface WTHistoryTableViewModel : NSObject {
	WTDataModel *model;
}

@property (nonatomic, retain) WTDataModel *model;

- (NSInteger)numberOfSectionsForSegment:(NSInteger)segement;
- (NSMutableArray *)headerTitlesForSegment:(NSInteger)segement;

@end