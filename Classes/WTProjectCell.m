//
//  WTProjectCell.m
//  WorkTracker
//
//  Created by Lucas Neiva on 10/12/09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import "WTProjectCell.h"

#pragma mark overlayView

@interface WTProjectCellContent : UIView
@end

@implementation WTProjectCellContent
- (void)drawRect:(CGRect)r {
	[(WTProjectCell *)self.superview drawOverlayView:r];
}
@end

#pragma mark 

@implementation WTProjectCell

static UIFont *firstTextFont= nil;
static UIFont *lastTextFont= nil;

+ (void)initialize {
	if(self == [WTProjectCell class]) {
		firstTextFont= [[UIFont boldSystemFontOfSize:20] retain];
		lastTextFont= [[UIFont systemFontOfSize:18] retain];
	}
}

@synthesize firstText;
@synthesize lastText;
@synthesize color;

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

- (void)setColor:(UIColor *)c {
	[color release];
	color= [c retain];
	[self setNeedsDisplay];
}

#pragma mark Draw

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[overlayView setNeedsDisplay];
}

-(void)layoutSubviews {
	[super layoutSubviews];
	CGRect f= self.bounds;
	
	// Move the overLayView
	if (self.editing) {
		f.origin.x+= 32;
		overlayView.frame= f;
		[overlayView setNeedsDisplay];
	} else {
		f.origin.x= 0;
		overlayView.frame= f;
		overlayView.clearsContextBeforeDrawing= NO;
		[overlayView performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
	}
}

- (void)drawContentView:(CGRect)r {
	CGContextRef context= UIGraphicsGetCurrentContext();
	
	// Background
	UIColor *backgroundColor= [color colorWithAlphaComponent:0.4];
	if (self.selected) {
		backgroundColor= [UIColor clearColor];
	} else {
		[[UIColor whiteColor] set]; 
		CGContextFillRect(context, r);
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	// Overlay
	if (!overlayView) {
		overlayView= [[WTProjectCellContent alloc] initWithFrame:contentView.frame];
		overlayView.backgroundColor= [UIColor clearColor];
		[self addSubview:overlayView];
	}
}

- (void)drawOverlayView:(CGRect)r {
	// Background
	CGContextRef context= UIGraphicsGetCurrentContext();
	
	r.size.height-= 1;
	
	UIColor *backgroundColor= [color colorWithAlphaComponent:0.4];
	if (self.selected) {
		backgroundColor= [UIColor clearColor];
	} else {
		[[UIColor whiteColor] set]; 
		CGContextFillRect(context, r);
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	// Content
	UIColor *textColor= [UIColor blackColor];
	[textColor set];
	
	CGPoint p= CGPointMake(12, (r.size.height - [firstText sizeWithFont:firstTextFont].height) / 2); // (sideSpacing, topSpacing)
	CGFloat lastTextWidth= MIN(100, [lastText sizeWithFont:lastTextFont].width);
	
	[firstText drawAtPoint:p forWidth:(320 - 2*p.x - lastTextWidth) withFont:firstTextFont lineBreakMode:UILineBreakModeTailTruncation];
	
	if (!self.editing)[lastText drawAtPoint:CGPointMake (320 - p.x - lastTextWidth, p.y + firstTextFont.pointSize - lastTextFont.pointSize)
								   forWidth:lastTextWidth
								   withFont:lastTextFont
							  lineBreakMode:UILineBreakModeTailTruncation];
}

#pragma mark -

- (void)dealloc {
	[firstText release];
	[lastText release];
	[color release];
	[overlayView release];
    [super dealloc];
}

@end
