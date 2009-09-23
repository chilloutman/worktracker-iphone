//
//  main.m
//  WorkTracker
//
//  Created by Lucas Neiva on 6/19/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc,argv,@"UIApplication",@"WorkTrackerAppDelegate");
    [pool release];
    return retVal;
}
