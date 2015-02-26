//
//  BaseViewController.m
//  calendar
//
//  Created by NextepMac on 1/6/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//


#import "BaseViewController.h"
#import "MainViewCell.h"
#import "HeaderViewCell.h"
#import "CellData.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "EventData.h"



@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize table, sidebarButton, topColor, back, calendar, topDate, dayBox, month, gesture, dayTitle, currentData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSString *urlAsString = @"http://nextep.ge/calendar/getDays";
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    arrDays = [[NSMutableArray alloc] init];
    arrMonth = [[NSMutableArray alloc] init];

    
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if(data != nil)
            [self parseJson:data];
   
    }];

    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //[self.table registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderViewCell"];
    
    [self.sidebarButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self setValues];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
  /*  [self.table scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:NO];
    */
}



- (void)parseJson:(NSData *)data{
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSError * error = localError;
        NSLog(@"%@", error);
    }
    
    int monthIndex = 1;
    int numInMonth = 0;
    NSArray * days = parsedObject[@"Data"][@"Days"];
    days = [days sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        int first = [((NSDictionary *)a)[@"Month"] intValue];
        int second = [((NSDictionary *)b)[@"Month"] intValue];
        if(first < second)
            return false;
        else if(first == second){
            int one = [((NSDictionary *)a)[@"Day"] intValue];
            int two = [((NSDictionary *)b)[@"Day"] intValue];
            if(one < two)
                return false;
            else
                return true;
        }
        return true;
    }];
    for ( NSDictionary *day in days ){
        NSString * numDay = [day[@"Day"] stringValue];
        int numMonth = [day[@"Month"] intValue];
        if(monthIndex == numMonth){
            numInMonth++;
        }
        else{
            [arrMonth insertObject:[NSString stringWithFormat:@"%d",numInMonth] atIndex:(monthIndex - 1)];
            monthIndex = numMonth;
            numInMonth = 1;
        }
        CellData * dayData = [CellData alloc];
        dayData.number = numDay;
        NSArray * events = day[@"Events"];
        dayData.events = [[NSMutableArray alloc] init];
        for(NSDictionary *event in events){
            EventData * eventData = [EventData alloc];
            eventData.eventId = [event[@"Id"] stringValue];
            eventData.catId = [event[@"CatId"] stringValue];
            eventData.image = event[@"Image"];
            eventData.name = event[@"Name"];
            eventData.eventDescription = event[@"Description"];
            [dayData.events addObject:eventData];
        }
        dayData.month = [self changeIntToMonth:numMonth];
        dayData.isWork = (BOOL)day[@"IsWork"];
        
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-2015", numDay, [NSString stringWithFormat:@"%d",numMonth]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:dateString];
        NSCalendar *calendars = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendars components:NSWeekdayCalendarUnit fromDate:dateFromString];
        int weekday = (int)[comps weekday];
        
        dayData.day = [self getWeekDay:weekday];
        
        [arrDays addObject:dayData];
        
    }
    sectionNumber = (int)[arrMonth count];
    [table reloadData];
}

- (NSString *)getWeekDay:(int)num{
    if(num == 2){
        return @"ორშაბათი";
    }
    else if(num == 3){
        return @"სამშაბათი";
    }
    else if(num == 4){
        return @"ოთხშაბათი";
    }
    else if(num == 5){
        return @"ხუთშაბათი";
    }
    else if(num == 6){
        return @"პარასკევი";
    }
    else if(num == 7){
        return @"შაბათი";
    }
    else if(num == 1){
        return @"კვირა";
    }
    return 0;
}


- (IBAction)moveToDay:(id)sender {
    [self performSegueWithIdentifier:@"view_day" sender:nil];
}

- (IBAction)moveToCalendar:(id)sender {
    [self performSegueWithIdentifier:@"view_cal" sender:nil];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)setValues{
    UIImage * image = [UIImage imageNamed:@"back.png"];
    [self.back setImage:image];
    [self.topColor setBackgroundColor:[UIColor colorWithRed:118.0/255.0 green:55.0/255.0 blue:116.0/255.0 alpha:0.9]];
    UIImage * imageBox = [UIImage imageNamed:@"day.png"];
    [self.dayBox setImage:imageBox];
    self.dayBox.layer.cornerRadius = 15;
    self.dayBox.layer.masksToBounds = YES;
    [self.topDate setText:@"9"];
    [self.month setText:@"აპრილი"];
    [self.dayTitle setText:@"ქალთა დღე"];
}

/*
- (void)setData{
    for(int i = 0; i < 120; i++){
        CellData * data = [CellData alloc];
        data.number = [NSString stringWithFormat:@"%d", i];
        data.title = @"satauri";
        data.day = @"paraskevi";
        if(i < 10)
            data.month = @"აპრილი";
        else
            data.month = @"მაისი";
        
        [arr addObject:data];
        
    }
}
*/

/*
- (void)scrollUp{
    NSIndexSet * indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 12)];
    sectionNumberUp = sectionNumberUp + 12;
    [self.table beginUpdates];
    [self.table insertSections:indexes withRowAnimation:UITableViewRowAnimationFade];
 //   CGPoint delayOffset = self.table.contentOffset;
 //   delayOffset = CGPointMake(delayOffset.x, delayOffset.y+ 120 * 46 + 12 * 30);
    
   
    
 //   [self.table setContentOffset:delayOffset animated:NO];
    [self.table endUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:12];
    [self.table scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:NO];
*/



- (void)scrollDown
{
    
    NSIndexSet * indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionNumber + 12, 12)];
    sectionNumber += 12;
    [self.table beginUpdates];
    [self.table insertSections:indexes withRowAnimation:UITableViewRowAnimationFade];
    
    [self.table endUpdates];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arrMonth objectAtIndex:section] intValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *simpleTableIdentifier = @"HeaderViewCell";
    //[[NSBundle mainBundle] loadNibNamed:@"HeaderCell" owner:self options:nil];
    HeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell setCellData:[self changeIntToMonth:((int)section + 1)]];
  
    return cell;
}

- (int)getNumberOfObjects:(int)section{
    int sum = 0;
    for(int i = 0; i < section; i++){
        sum += [[arrMonth objectAtIndex:i] intValue];
    }
    return sum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MainViewCell";
    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    int num = [self getNumberOfObjects:(int)indexPath.section];
    CellData *data = [arrDays objectAtIndex:indexPath.row + num];
    cell.month = data.month;
    [cell setCellData:data];
    
    if((indexPath.section%12) == 11 && indexPath.row == ([[arrMonth objectAtIndex:indexPath.section] intValue] - 1)){
        if(indexPath.section == sectionNumber + 11){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollDown];
            });
        }
    }
    /*
    if(indexPath.section == 1 && indexPath.row == 0){
        if(indexPath.section == sectionNumberUp + 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollUp];
            });
        }

    }
    if(sectionNumberUp != 0){
        sectionNumberUp = 0;
        sectionNumberDown += 12;
    } */
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(NSString *)changeIntToMonth:(int)num{
    if(num == 1)
        return @"იანვარი";
    else if(num == 2){
        return @"თებერვალი";
    }
    else if(num == 3){
        return @"მარტი";
    }
    else if(num == 4){
        return @"აპრილი";
    }
    else if(num == 5){
        return @"მაისი";
    }
    else if(num == 6){
        return @"ივნისი";
    }
    else if(num == 7){
        return @"ივლისი";
    }
    else if(num == 8){
        return @"აგვისტო";
    }
    else if(num == 9){
        return @"სექტემბერი";
    }
    else if(num == 10){
        return @"ოქტომბერი";
    }
    else if(num == 11){
        return @"ნოემბერი";
    }
    else if(num == 12){
        return @"დეკემბერი";
    }
    return 0;
}


-(NSString *)changeMonth:(NSString *)months{
    if([months isEqual:@"იანვარი"]){
        return @"1";
    }
    else if([months isEqual:@"თებერვალი"]){
        return @"2";
    }
    else if([months isEqual:@"მარტი"]){
        return @"3";
    }
    else if([months isEqual:@"აპრილი"]){
        return @"4";
    }
    else if([months isEqual:@"მაისი"]){
        return @"5";
    }
    else if([months isEqual:@"ივნისი"]){
        return @"6";
    }
    else if([months isEqual:@"ივლისი"]){
        return @"7";
    }
    else if([months isEqual:@"აგვისტო"]){
        return @"8";
    }
    else if([months isEqual:@"სექტემბერი"]){
        return @"9";
    }
    else if([months isEqual:@"ოქტომბერი"]){
        return @"10";
    }
    else if([months isEqual:@"ნოემბერი"]){
        return @"11";
    }
    else if([months isEqual:@"დეკემბერი"]){
        return @"12";
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainViewCell *cell = (MainViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString * day = cell.number.text;
    [self.topDate setText:day];
 //   HeaderViewCell *header = (HeaderViewCell *)[tableView headerViewForSection:indexPath.section];
  //  NSString * months = header.title.text;
    NSString * months = cell.month;
    [self.month setText:months];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    int k =([[arrMonth objectAtIndex:indexPath.section] intValue] - 1);
    if(row == k){
        row = 0;
        section ++;
    }
    else
        row ++;
    self.currentData = [DayData alloc];
    self.currentData.day = day;
    self.currentData.month = [self changeMonth:months];
    self.currentData.year = @"2015";
    
    if(section < sectionNumber)
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
