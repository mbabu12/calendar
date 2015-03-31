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
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppSettings.h"


@interface DayViewController () 


@end


@implementation DayViewController
@synthesize topColor, back, calendar, sidebarButton, backMain, previous;


- (void)viewDidLoad
{
    [super viewDidLoad];
    show = NO;
    
    [self addCategories];
    
    self.defButton.layer.cornerRadius = 5; // this value vary as per your desire
    self.defButton.clipsToBounds = YES;
    self.allEvents = [[NSMutableArray alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.parsedObject = [defaults objectForKey:@"allData"];
    
    [self.defButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    self.revealViewController.panGestureRecognizer.enabled = NO;
    
    AppSettings *appSettings = [AppSettings sharedInstance];
    self.allMonth = appSettings.arrMonth;
    self.allDays = appSettings.arrDay;
    
    textViews = [[NSMutableArray alloc] init];
    self.previous = @"";
    self.curDate = self.currentData.day;
    self.curMonth = self.currentData.month;
    
    
    [self setEvents];
    
    self.eventTable.delegate = self;
    self.eventTable.dataSource = self;
    [self.eventTable setBackgroundColor:[UIColor whiteColor]];
    
    [self.back setHidden:NO];
    [self.topColor setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dayChangeNotification:)
                                                 name:@"dayChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"changeCategory"
                                               object:nil];
    
    self.scrollDays = [[ScrollDayView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 100)];
    [self.scrollDays startDate:self.currentData];
    [self.scrollDays addDays];
    [self.view addSubview:self.scrollDays];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.enabled = NO;
}

- (void)addCategories{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"categories"] != nil){
        showCategories = [[defaults objectForKey:@"categories"] mutableCopy];
    }
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    AppSettings *appSettings = [AppSettings sharedInstance];
    if ([[notification name] isEqualToString:@"changeCategory"]){
        [self.allDays removeAllObjects];
     //   [self.allEvents removeAllObjects];
        [self.allMonth removeAllObjects];
        [self addCategories];
        [self parseData];
        [appSettings.array removeAllObjects];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"dayChanged"
         object:self];

        
    }
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



- (void)parseData{
    int monthIndex = 1;
    int numInMonth = 0;
    AppSettings *appSettings = [AppSettings sharedInstance];
    appSettings.year = [[NSString alloc] init];
    appSettings.year = [self.parsedObject[@"Data"][@"Year"] stringValue];
    NSArray * days = self.parsedObject[@"Data"][@"Days"];
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
            eventData.priority = [event[@"O"] stringValue];
            
            if([showCategories containsObject:eventData.catId] || [eventData.catId isEqualToString:@"3"])
                [dayData.events addObject:eventData];
        }
        if([dayData.events count] > 0){
        
            dayData.events = (NSMutableArray *)[dayData.events sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                int first = [((EventData *)a).priority intValue];
                int second = [((EventData *)b).priority intValue];
                if(first < second)
                    return false;
                else
                    return true;
            }];
            

            
            if(monthIndex == numMonth){
                numInMonth++;
                
            }
            else{
                if([self.allMonth count] != monthIndex - 1){
                    for(int i = (int)([self.allMonth count] - 1); i < monthIndex - 2; i++){
                        [self.allMonth addObject:@"0"];
                    }
                }
                [self.allMonth insertObject:[NSString stringWithFormat:@"%d",numInMonth] atIndex:(monthIndex - 1)];
                monthIndex = numMonth;
                numInMonth = 1;
            }
            
            
            dayData.month = [self changeIntToMonth:numMonth];
            dayData.isWork = [day[@"IsWork"] boolValue];
            
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", numDay, [NSString stringWithFormat:@"%d",numMonth], appSettings.year];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            NSCalendar *calendars = [NSCalendar currentCalendar];
            NSDateComponents *comps = [calendars components:NSWeekdayCalendarUnit fromDate:dateFromString];
            int weekday = (int)[comps weekday];
            
            dayData.day = [self getWeekDay:weekday];
            
            [self.allDays addObject:dayData];
        }
        
    }
    
    if([((CellData *)self.allDays.lastObject).month intValue] != [self.allMonth count] || numInMonth != 1){
        for(int i = (int)([self.allMonth count] - 1); i < monthIndex - 2; i++){
            [self.allMonth addObject:@"0"];
        }
        
        [self.allMonth insertObject:[NSString stringWithFormat:@"%d",numInMonth] atIndex:(monthIndex - 1)];
    }
    
    appSettings.arrMonth = self.allMonth;
    appSettings.arrDay = self.allDays;
   
    
}


- (void) setEvents{
    
    CellData * cur = [CellData alloc];
    int months = [self.curMonth intValue];
    int day = [self.curDate intValue];
    if([self.allMonth count] > (months - 1)){
        int numInMonth = [[self.allMonth objectAtIndex:(months - 1)] intValue];
        if(numInMonth != 0){
            int index = 0;
            for(int i = 0; i < (months - 1); i++){
                index += [[self.allMonth objectAtIndex:i] intValue];
            }
            int j = index - 1;
            if(j < 0)
                j = 0;
            for(j; j < (index + numInMonth); j++){
                if([self.allDays count] > j){
                    CellData * temp = [self.allDays objectAtIndex:j];
                    if([temp.number intValue] == day){
                        cur = temp;
                        break;
                    }
                }
            }
        }
    }
    self.allEvents = cur.events;
    for(int i = 0; i < [cur.events count]; i++){
       [textViews insertObject:[NSNumber numberWithFloat:[self textViewHeightForAttributedText:((EventData *)[cur.events objectAtIndex:i]).eventDescription andWidth:(self.view.bounds.size.width - 40)]] atIndex:i];
    }
    UIImage * image;
    if([cur.events count] == 0){
        image = [UIImage imageNamed:@"default.png"];
        [self.defTitle setHidden:NO];
        [self.defText setHidden:NO];
        [self.defButton setHidden:NO];
        [self.eventTable setHidden:YES];
    }
 //   UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", self.startUrl, ((EventData *)[self.allEvents objectAtIndex:0]).image]]]];
   
    else{
        image = [UIImage imageNamed:@"back.png"];
        [self.defTitle setHidden:YES];
        [self.defText setHidden:YES];
        [self.defButton setHidden:YES];
        [self.eventTable setHidden:NO];

    }
    [self.back setImage:image];

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                  }];
    
    return urlWasHandled;
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}




- (IBAction)clickShare:(id)sender{
    int index = [sender tag];
    EventData * temp = [self.allEvents objectAtIndex:index];
    
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       temp.name, @"name",
                                       [NSString stringWithFormat:@"გილოცავთ! დღეს არის %@", temp.name], @"caption",
                                       @"", @"description",
                                       @"http://nextep.ge/calendar", @"link",
                                       @"", @"picture",
                                       nil];
 
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    

  }




-(void)enableViewContent:(BOOL)enable{
    [self.scrollDays enableScroll:enable];
    self.calendar.enabled = enable;
    self.revealViewController.panGestureRecognizer.enabled = !enable;
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

- (CGFloat)textViewHeightForAttributedText: (NSString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setFont:[UIFont systemFontOfSize:12]];
    calculationView.scrollEnabled = NO;
    [calculationView setText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height + 30;
}

- (IBAction)viewCal:(id)sender {
    [self performSegueWithIdentifier:@"view_cal2" sender:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(!show){
        [self.scrollDays removeFromSuperview];
    //    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //    self.revealViewController.panGestureRecognizer.enabled = YES;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[textViews objectAtIndex:indexPath.section] floatValue];
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
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.button.tag = section;
    return cell;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DescriptionCell";
    DescriptionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell.text setText:((EventData *)[self.allEvents objectAtIndex:indexPath.section]).eventDescription];
    cell.text.scrollEnabled = NO;
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
