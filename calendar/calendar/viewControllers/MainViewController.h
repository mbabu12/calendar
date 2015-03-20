//
//  MainViewController.h
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayData.h"
#import "BaseViewController.h"

@interface MainViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray * arrDays;
    NSMutableArray * arrMonth;
    int sectionNumber;
    NSMutableArray * showCategories;
    NSMutableArray * notEmpty;
    int sections;
    NSMutableDictionary * monthsNum;
    BOOL isClicked;
    int curIndex;
}

@property (weak, nonatomic) IBOutlet UIImageView *topColor;
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIImageView *dayBox;
@property (weak, nonatomic) IBOutlet UILabel *topDate;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UIButton *calendar;
@property (weak, nonatomic) IBOutlet UILabel *dayTitle;
@property (weak, nonatomic) IBOutlet UILabel *defaultTitle;
@property (weak, nonatomic) IBOutlet UILabel *defaultText;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (strong, nonatomic) NSString * startUrl;
@property (strong, nonatomic) NSData * allDaysData;
@property (strong, nonatomic) NSDictionary * parsedObject;
@property (strong, nonatomic) NSDictionary * parsedObjectCat;


- (void)parseData;
    
@end

