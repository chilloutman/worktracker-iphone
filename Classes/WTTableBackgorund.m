//
//  WTTableBackgorund.m
//  WorkTracker
//
//  Created by Lucas Neiva on 14.07.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WTTableBackgorund.h"
#import "WTConstants.h"

@implementation WTTableBackgorund

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(ctx, rect);
	
	CGContextSetRGBFillColor(ctx, cColorLightGrayCG);
    CGContextFillRect(ctx, rect);
	
	CGImageRef shadow= [[UIImage imageNamed:@"shadow.png"] CGImage]; // trick: This inverts the image
	CGContextDrawImage(ctx, CGRectMake(0, rect.size.height - 50, rect.size.width, 60), shadow);
}

- (void)dealloc {
    [super dealloc];
}


@end
