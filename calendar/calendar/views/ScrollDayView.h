//
//  ScrollDayView.h
//  calendar
//
//  Created by NextepMac on 2/13/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayData.h"

@interface ScrollDayView : UIView{
    NSMutableArray * arrDays;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat bigY;
    CGFloat widthBig;
    NSDate * minDate;
    NSDate * maxDate;
}

- (void)addDays;
- (void)myInitialization;
- (void)startDate:(DayData *)data;
- (NSDate *)getCurDate;

@property (strong, nonatomic) NSDate * startData;

@end
