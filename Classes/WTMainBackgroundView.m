//
//  WTMainBackgroundView.m
//  WorkTracker
//
//  Created by Lucas Neiva on 13.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTMainBackgroundView.h"

@implementation WTMainBackgroundView

- (id)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect screen= [[UIScreen mainScreen] applicationFrame];
	
	CGContextClearRect(ctx, rect);
	
	UIImage *backgroundImage= [UIImage imageNamed:@"background-small.png"];
	[backgroundImage drawInRect:CGRectMake(0, 0, screen.size.width, 250)];
	
	CGContextSetRGBFillColor(ctx, 0.9, 0.9, 0.9, 1);
    CGContextFillRect(ctx, CGRectMake(0, screen.size.height / 2 + 2, screen.size.width, screen.size.height / 2 - 50));
	
	UIImage *shadow= [UIImage imageNamed:@"shadow.png"];
	[shadow drawInRect:CGRectMake(0, screen.size.height / 2 + 2, screen.size.width, 60)];
	
	//CGImageRef shadow= [[UIImage imageNamed:@"shadow.png"] CGImage]; // trick: This inverts the image
	//CGContextDrawImage(ctx, CGRectMake(0, screen.size.height / 2 + 2, screen.size.width, screen.size.height / 2 - 50), shadow);
}

- (void)dealloc {
    [super dealloc];
}

@end
