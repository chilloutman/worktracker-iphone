//
//  WTTableSectionHeader.m
//  WorkTracker
//
//  Created by Lucas Neiva on 17.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTTableSectionHeader.h"


@implementation WTTableSectionHeader

static UIFont *font= nil;
static UILabel *label= nil;

@synthesize firstText, lastText;

+ (void)initialize {
	font= [[UIFont boldSystemFontOfSize:18] retain];
	
	// UILabel helps me to draw the strings with shadows
	label= [[UILabel alloc] initWithFrame:CGRectZero];
	label.font= font;
	label.backgroundColor= [UIColor clearColor];
	label.textColor= [UIColor whiteColor];
	label.shadowColor= [UIColor darkGrayColor];
	label.shadowOffset= CGSizeMake(0, 0.5);
}

- (id)initWithFrame:(CGRect)frame {
	if (self= [super initWithFrame:frame]) {
		// Initialization code		
	}
	return self;
}

#pragma mark -

// the reason I don't synthesize setters for 'firstText' and 'lastText' is because I need to
// call -setNeedsDisplay when they change
- (void)setFirstText:(NSString *)s {
	[firstText release];
	firstText= [s copy];
	[self setNeedsDisplay];
}

- (void)setLastText:(NSString *)s {
	[lastText release];
	lastText= [s copy];
	[self setNeedsDisplay]; 
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
	
	// Backgournd
	UIImage *background= [UIImage imageNamed:@"tableSectionHeader.png"];
	[background drawAtPoint:CGPointMake(rect.origin.x, rect.origin.y)];
	
	// First Label
	CGSize labelSize= [firstText sizeWithFont:font];
	CGPoint p= CGPointMake(12, (rect.size.height - labelSize.height) / 2);
	label.text= firstText;
	[label drawTextInRect:CGRectMake(p.x, p.y, labelSize.width, labelSize.height)];
	
	// Second Label
	labelSize= [lastText sizeWithFont:font];
	label.text= lastText;
	[label drawTextInRect:CGRectMake(rect.size.width - labelSize.width - p.x, p.y, labelSize.width, labelSize.height)];
}

#pragma mark -

- (void)dealloc {
    [super dealloc];
}


@end
