//
//  WTProjectAddViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 09.07.09.
//  ***
//

#import <UIKit/UIKit.h>

@class WTProjects;

@interface WTProjectAdd : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	UIBarButtonItem *doneButton;
	UITableView * tableView;
	UITextField *nameField;
	UITextField *clientField;
	UISegmentedControl *colorPicker;
	NSArray *colors;
	UIColor *projectColor;
	
	WTProjects *superController;
}

@property (nonatomic, retain) WTProjects *superController;

- (void)dismissView;

@end
