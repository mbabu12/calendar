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
#import "CellData.h"
#import "EventData.h"
#import "HeaderCategoryViewCell.h"


@implementation CalendarViewController
@synthesize menu, content, calendar, buttonSideBar, top, table, delegate;

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    arr = [[NSMutableArray alloc] init];
    headers = [[NSMutableArray alloc] init];
    data = [[NSMutableArray alloc] init];
    textViews = [[NSMutableArray alloc] init];
    
    [self setData:[NSDate date]];
    [self getCategories];
    
    [self.buttonSideBar addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
   
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.calendar = [[JTCalendar alloc]init];
    [self.calendar setMenuMonthsView:self.menu];
    [self.calendar setContentView:self.content];
    [self.calendar setDataSource:self];
    
    
    [self.top setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:172.0/255.0 blue:202.0/255.0 alpha:1]];
    
}

-(void)getCategories{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"categories"] != nil){
  //      showCategories = [[defaults objectForKey:@"categories"] mutableCopy];
    }

}

-(void)enableViewContent:(BOOL)enable{
    [self.calendar enableViewContent:enable];
    self.table.userInteractionEnabled = enable;
}

- (CGFloat)textViewHeightForAttributedText: (NSString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setFont:[UIFont systemFontOfSize:12]];
    calculationView.scrollEnabled = NO;
    [calculationView setText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)setData:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    
    CellData * current = [CellData alloc];
    int numInMonth = [[self.allMonth objectAtIndex:(month - 1)] intValue];
    if(numInMonth != 0){
        int index = 0;
        for(int i = 0; i < (month - 1); i++){
            index += [[self.allMonth objectAtIndex:i] intValue];
        }
        int j = index - 1;
        if(j < 0)
            j = 0;
        for(j; j < (index + numInMonth); j++){
            CellData * temp = [self.allDays objectAtIndex:j];
            if([temp.number intValue] == day){
                current = temp;
                break;
            }
        }
        
    }
    
    [arr addObject:[NSNumber numberWithBool:NO]];
    NSMutableArray * events = [current events];
    for(int i = 0; i < [events count]; i++){
        EventData * temp = [events objectAtIndex:i];
        [textViews insertObject:[NSNumber numberWithFloat:[self textViewHeightForAttributedText:temp.eventDescription andWidth:(self.view.bounds.size.width - 40)]] atIndex:i];
        [arr addObject:[NSNumber numberWithBool:NO]];
        [headers addObject:temp.name];
        [data addObject:temp.eventDescription];
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
    [arr removeAllObjects];
    [headers removeAllObjects];
    [data removeAllObjects];
    [self setData:date];
    [self.table reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [headers count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[arr objectAtIndex:section] boolValue])
        return 2;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[arr objectAtIndex:indexPath.section] boolValue]){
        if(indexPath.row == 0){
            if(indexPath.section == 0)
                return 24.0;
            return 46.0;
        }
        else
            return [[textViews objectAtIndex:indexPath.section - 1] floatValue] + 15;
    }
    else
        return 46.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        if(indexPath.section == 0){
            static NSString *CellIdentifier = @"HeaderCategoryViewCell";
            HeaderCategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            return cell;
        }
        static NSString *CellIdentifier = @"HeaderCell";
        HeaderCalViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
        [cell.title setText:[headers objectAtIndex:indexPath.section - 1]];
        if(![[arr objectAtIndex:indexPath.section] boolValue])
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else{
        if([[arr objectAtIndex:indexPath.section] boolValue]){
            static NSString *CellIdentifier = @"DescCell";
            DescriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            [cell.text setText:[data objectAtIndex:indexPath.section - 1]];
            cell.text.scrollEnabled = NO;
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
