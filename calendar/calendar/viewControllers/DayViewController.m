//
//  DayViewController.m
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "DayViewController.h"
#import "CellData.h"
#import "DayTitleViewCell.h"
#import "DescriptionViewCell.h"



@interface DayViewController () 


@end


@implementation DayViewController
@synthesize topColor, back, calendar, sidebarButton, backMain, previous;


- (void)viewDidLoad
{
    [super viewDidLoad];
    show = NO;
    
    self.previous = @"";
    self.curDate = self.currentData.day;
    self.curMonth = self.currentData.month;
    
    [self setEvents];
    
    self.eventTable.delegate = self;
    self.eventTable.dataSource = self;
    
    [self.back setHidden:NO];
    [self.topColor setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dayChangeNotification:)
                                                 name:@"dayChanged"
                                               object:nil];
    
    self.scrollDays = [[ScrollDayView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 100)];
    [self.scrollDays startDate:self.currentData];
    [self.scrollDays addDays];
    [self.view addSubview:self.scrollDays];
}

- (void) setEvents{
    int index = 0;
    for(int i = 0; i < ([self.curMonth intValue] - 1); i++){
        index += [[self.allMonth objectAtIndex:i] intValue];
    }
    
    index = index + [self.curDate intValue] - 1;
    CellData * cur = [self.allDays objectAtIndex:index];
    self.allEvents = cur.events;

}

- (void) dayChangeNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"dayChanged"]){
        NSDate * temp = [self.scrollDays getCurDate];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:temp];
        self.curMonth = [NSString stringWithFormat:@"%d", (int)components.month];
        self.curDate = [NSString stringWithFormat:@"%d", (int)components.day];
        [self setEvents];
        [self.eventTable reloadData];
    }
}


- (void)changeItem:(CalendarViewController *)controller
{
    show = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"view_cal2"])
    {
        show = YES;
        CalendarViewController * calendarView = [segue destinationViewController];
        calendarView.delegate = self;
    }
}

- (IBAction)viewCal:(id)sender {
    [self performSegueWithIdentifier:@"view_cal2" sender:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(!show)
        [self.scrollDays removeFromSuperview];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.allEvents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *simpleTableIdentifier = @"DayTitleViewCell";
    DayTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell.title setText:((EventData *)[self.allEvents objectAtIndex:section]).name];
    
    return cell;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DescriptionCell";
    DescriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell.text setText:((EventData *)[self.allEvents objectAtIndex:indexPath.section]).eventDescription];
    return cell;

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



@end
