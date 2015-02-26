//
//  BaseViewController.h
//  calendar
//
//  Created by NextepMac on 1/6/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayData.h"

@interface BaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * arrDays;
    NSMutableArray * arrMonth;
    int sectionNumber;
    
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *sidebarButton;
@property (weak, nonatomic) IBOutlet UIImageView *topColor;
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIImageView *dayBox;
@property (weak, nonatomic) IBOutlet UILabel *topDate;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UIButton *calendar;
@property (weak, nonatomic) IBOutlet UILabel *dayTitle;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gesture;

@property (nonatomic, readwrite, retain) DayData * currentData;


-(void)setValues;
@end

