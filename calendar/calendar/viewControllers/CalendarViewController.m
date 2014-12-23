//
//  CalendarViewController.m
//  calendar
//
//  Created by NextepMac on 12/19/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "CalendarViewController.h"
#import "SWRevealViewController.h"


@implementation CalendarViewController

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    [self.buttonSideBar addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
    self.calendar = [JTCalendar new];
    [self.calendar setMenuMonthsView:self.menu];
    [self.calendar setContentView:self.content];
    [self.calendar setDataSource:self];
    
}



- (void)viewDidAppear:(BOOL)animated

{
    
    [super viewDidAppear:animated];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    
}



- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date

{
    
    return NO;
    
}



- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date

{
    
    NSLog(@"%@", date);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
