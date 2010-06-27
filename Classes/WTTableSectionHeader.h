//
//  WTTableSectionHeader.h
//  WorkTracker
//
//  Created by Lucas Neiva on 17.07.09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTableSectionHeader : UIView {
	NSString *firstText;
	NSString *lastText;
}

@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *lastText;

@end
