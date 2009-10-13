//
//  WTTableViewCell.h
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"

@interface WTIntervalCell : ABTableViewCell {
	NSString *firstText;
	NSString *lastText;
}

@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *lastText;

@end
