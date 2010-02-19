//
//  WTTrackingDetails.h
//  WorkTracker
//
//  Created by Lucas Neiva on 01.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTTrackingDetails : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableDictionary *activities;
	UITableView *tableView;
	
	BOOL displayingComment;
	UITextView *commentLabel;
}

- (id)initWithActivity:(NSMutableDictionary *)pActivity;

@end
