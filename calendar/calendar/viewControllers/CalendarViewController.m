//
//  CalendarViewController.m
//  calendar
//
//  Created by NextepMac on 12/19/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "CalendarViewController.h"
#import "SWRevealViewController.h"
#import "HeaderCalViewCell.h"
#import "DescriptionViewCell.h"



@implementation CalendarViewController
@synthesize menu, content, calendar, buttonSideBar, top, table, delegate;

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    arr = [[NSMutableArray alloc] init];
    headers = [[NSMutableArray alloc] init];
    data = [[NSMutableArray alloc] init];
    [self setData];
    
    [self.buttonSideBar addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.calendar = [[JTCalendar alloc]init];
    [self.calendar setMenuMonthsView:self.menu];
    [self.calendar setContentView:self.content];
    [self.calendar setDataSource:self];
    
    
    [self.top setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:172.0/255.0 blue:202.0/255.0 alpha:1]];
    
}

- (void)setData{
    for(int i = 0; i < 3; i++){
        [arr addObject:[NSNumber numberWithBool:NO]];
        [headers addObject:@"satauri"];
        [data addObject:@"teqsti"];
    }
}


- (void)viewDidAppear:(BOOL)animated

{
    
    [super viewDidAppear:animated];
    [self.calendar reloadData]; // Must be call in viewDidAppear
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.calendar clearAll];
    [self.content removeFromSuperview];
    [self.menu removeFromSuperview];
    self.calendar = nil;
    [self.delegate changeItem:self];
}


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date

{
    
    return NO;
    
}



- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date

{
    
    NSLog(@"%@", date);
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [headers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[arr objectAtIndex:section] boolValue])
        return 2;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"HeaderCell";
        HeaderCalViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        [cell.title setText:[headers objectAtIndex:indexPath.section]];
        if(![[arr objectAtIndex:indexPath.section] boolValue])
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else{
        if([[arr objectAtIndex:indexPath.section] boolValue]){
            static NSString *CellIdentifier = @"DescCell";
            DescriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            [cell.text setText:[data objectAtIndex:indexPath.section]];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        if([[arr objectAtIndex:indexPath.section] boolValue]){
            [arr replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
        }
        else{
            [arr replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:YES]];
        }
         [table reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.calendar = nil;
}



@end
