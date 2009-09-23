//
//  WTTableViewCell.m
//  WorkTracker
//
//  Created by Lucas Neiva on 15.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTTableViewCell.h"

@implementation WTTableViewCell

@synthesize firstText;
@synthesize lastText;

static UIFont *firstTextFont= nil;
static UIFont *lastTextFont= nil;

+ (void)initialize {
	if(self == [WTTableViewCell class]) {
		firstTextFont= [[UIFont boldSystemFontOfSize:20] retain];
		lastTextFont= [[UIFont systemFontOfSize:18] retain];
		// this is a good spot to load any graphics you might be drawing in -drawContentView:
		// just load them and retain them here (ONLY if they're small enough that you don't care about them wasting memory)
		// the idea is to do as LITTLE work (e.g. allocations) in -drawContentView: as possible
	}
}

// the reason I don't synthesize setters for 'firstText' and 'lastText' is because I need to
// call -setNeedsDisplay when they change
- (void)setFirstText:(NSString *)s {
	[firstText release];
	firstText = [s copy];
	[self setNeedsDisplay];
}

- (void)setLastText:(NSString *)s {
	[lastText release];
	lastText = [s copy];
	[self setNeedsDisplay]; 
}

#pragma mark Draw

- (void)drawContentView:(CGRect)r {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor= [UIColor whiteColor];
	UIColor *textColor= [UIColor blackColor];
	
	if (self.selected) {
		backgroundColor= [UIColor clearColor];
		textColor= [UIColor whiteColor];
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	
	[textColor set];
	CGPoint p= CGPointMake(12, (r.size.height - [firstText sizeWithFont:firstTextFont].height) / 2); // (sideSpacing, topSpacing)
	CGSize lastTextSize= [lastText sizeWithFont:lastTextFont];
	
	[firstText drawAtPoint:p forWidth:(320 - 2*p.x - lastTextSize.width) withFont:firstTextFont lineBreakMode:UILineBreakModeTailTruncation];
		
	[lastText drawAtPoint:CGPointMake (320 - p.x - lastTextSize.width, p.y + firstTextFont.pointSize - lastTextFont.pointSize) withFont:lastTextFont];
}

#pragma mark -

- (void)dealloc {
	[firstText release];
	[lastText release];
    [super dealloc];
}

@end
