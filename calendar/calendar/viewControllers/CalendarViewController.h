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

@interface CalendarViewController : UIViewController<JTCalendarDataSource, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray * arr;
    NSMutableArray * headers;
    NSMutableArray * data;
}
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *menu;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *content;
@property (strong, nonatomic) JTCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *buttonSideBar;
@property (weak, nonatomic) IBOutlet UIImageView *top;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end
