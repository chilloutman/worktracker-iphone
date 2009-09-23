//
//  WorkTrackerAppDelegate.h
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkTrackerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, assign) UIWindow *window;
@property (nonatomic, assign) UITabBarController *tabBarController;

@end

