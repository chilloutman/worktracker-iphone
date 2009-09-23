//
//  WTProjectAddViewController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 09.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTProjectsViewController;

@interface WTProjectAdd : UIViewController <UITextFieldDelegate> {
	UITextField *textField;
	UIBarButtonItem *doneButton;
	WTProjectsViewController *superController;
}

@property (nonatomic, retain) WTProjectsViewController *superController;

@end
