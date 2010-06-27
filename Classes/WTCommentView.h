//
//  WTCommentView.h
//  WorkTracker
//
//  Created by Lucas Neiva on 11/13/09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTCommentView : UIViewController {
	UITextView *commentField;
}

@property (nonatomic, assign) UITextView *commentField;

@end
