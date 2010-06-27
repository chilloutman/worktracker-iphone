//
//  WTStartTrackingRootController.h
//  WorkTracker
//
//  Created by Lucas Neiva on 11/13/09.
//  ***
//

#import <UIKit/UIKit.h>

@class WTMainViewController, WTProjectPicker;

@interface WTStartTrackingRootController : UIViewController <UINavigationControllerDelegate> {
	UINavigationController *navController;
	WTMainViewController *superController;
	WTProjectPicker *tableController;
}

@property (nonatomic, retain) WTMainViewController *superController;

@end