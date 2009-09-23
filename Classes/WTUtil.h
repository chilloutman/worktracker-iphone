//
//  WTUtil.h
//  WorkTracker
//
//  Created by Lucas Neiva on 28.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WTUtil : NSObject {

}

+ (NSString *)dayForDate:(NSDate *)pDate;
+ (NSString *)weekForDate:(NSDate *)pDate;

@end
