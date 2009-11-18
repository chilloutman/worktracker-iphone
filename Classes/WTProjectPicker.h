//
//  WTProjectPicker.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTMainViewController, WTCommentView;

@interface WTProjectPicker : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
	UIPickerView *picker;
	
	WTMainViewController *superController;
	WTCommentView *commentView;
}

@property (nonatomic, retain) WTCommentView *commentView;
@property (nonatomic, assign) UIPickerView *picker;
@property (nonatomic, retain) WTMainViewController *superController;

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end
