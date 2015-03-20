//
//  CalendarViewController.h
//  calendar
//
//  Created by NextepMac on 12/19/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JTCalendar.h"


@class CalendarViewController;

@protocol CalendarViewControllerDelegate <NSObject>

- (void)changeItem:(CalendarViewController *)controller;

@end

@interface CalendarViewController : UIViewController<JTCalendarDataSource, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray * arr;
    NSMutableArray * headers;
    NSMutableArray * data;
    NSMutableArray * textViews;

}

@property (nonatomic, weak) id <CalendarViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menu;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *content;
@property (strong, nonatomic) JTCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *buttonSideBar;
@property (weak, nonatomic) IBOutlet UIImageView *top;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) NSMutableArray * allDays;
@property (strong, nonatomic) NSMutableArray * allMonth;
-(void)enableViewContent:(BOOL)enable;

@end
