//
//  WTInfo.h
//  WorkTracker
//
//  Created by Lucas Neiva on 30.09.09.
//  ***
//

#import <UIKit/UIKit.h>


@interface WTInfo : UIViewController {
	UIViewController *superController;
}

@property (nonatomic, retain) UIViewController *superController;

- (UITextView *)infoTextViewWithText:(NSString *)text;

@end
