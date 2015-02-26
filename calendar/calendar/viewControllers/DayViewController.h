//
//  DayViewController.h
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "ScrollDayView.h"
#import "CalendarViewController.h"
#import "EventData.h"


@interface DayViewController : BaseViewController<CalendarViewControllerDelegate>{
    @public
        BOOL show;
}

@property (weak, nonatomic) IBOutlet UIImageView *topColor;
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIButton *calendar;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *backMain;
@property (strong, nonatomic) NSString * previous;


@property (strong, nonatomic) ScrollDayView * scrollDays;
@property (strong, nonatomic) NSString * curDate;
@property (strong, nonatomic) NSString * curMonth;
@property (strong, nonatomic) NSString * curYear;

@property (strong, nonatomic) NSMutableArray * allDays;
@property (strong, nonatomic) NSMutableArray * allMonth;

@property (strong, nonatomic) NSMutableArray * allEvents;

@property (weak, nonatomic) IBOutlet UITableView *eventTable;

@end
