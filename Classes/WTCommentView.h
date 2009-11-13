//
//  WTCommentView.h
//  WorkTracker
//
//  Created by Lucas Neiva on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTCommentView : UIViewController {
	UITextView *commentView;
}

@property (nonatomic, assign) UITextView *commentView;

@end
