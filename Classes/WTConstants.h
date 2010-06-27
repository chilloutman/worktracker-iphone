//
//  WTConstants.m
//  WorkTracker
//
//  Created by Lucas Neiva on 7/12/09.
//  Copyright 2010 Lucas Neiva. All rights reserved.
//

// UI
#define cButtonFrame	CGRectMake(0, 0, 140, 50)
#define cTimeRefreshRate 3.6

// Some Chars ‣ ► ▶ ↻

// Emojis:
#define cCharCircleGreen @""
#define cCharCircleRed @""
#define cCharMagnifyingGlass @""
#define cCharCautionSign @""
#define cCharSleeping @""


// Colors
#define UIColorFromRGB(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 \
green:((c>>8)&0xFF)/255.0 \
blue:(c&0xFF)/255.0 \
alpha:1.0]

#define cColorLightGray		[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]
#define cColorLightGrayCG	0.9, 0.9, 0.9, 1

// WTDataModel keys
extern NSString * const cProjects;
extern NSString * const cActivities;
extern NSString * const cStatus;

// Activity : NSMutableDictionary keys
#define cIntervalDictSize 5
extern NSString * const cProject;
extern NSString * const cStartTime;
extern NSString * const cStopTime;
extern NSString * const cTimeInterval;
extern NSString * const cComment;

// Project : NSMutableDictionary keys
#define cProjectDictSize 4
extern NSString * const cProjectNumber;
extern NSString * const cProjectTime;
extern NSString * const cProjectColor;
extern NSString * const cProjectClient;

// Engine Keys
extern NSString * const cTimerMainView;
extern NSString * const cTimerHistoryView;

// Sorting types which indicate how the intervals should be sorted
typedef enum {
	WTSortingByDay= 0,
	WTSortingByWeek= 1,
	WTSortingByMonth= 2,
	WTSortingAll= 10
} WTSortingType;

