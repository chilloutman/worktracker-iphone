//
//  WTProjectCell.h
//  WorkTracker
//
//  Created by Lucas Neiva on 10/12/09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import "ABTableViewCell.h"

@class ABTableViewCell;

@interface WTProjectCell : ABTableViewCell {
	UIView *overlayView;
	
	UIColor *color;
	NSString *firstText;
	NSString *lastText;
}

@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *lastText;
@property (nonatomic, retain) UIColor *color;

- (void)drawOverlayView:(CGRect)r;

@end
