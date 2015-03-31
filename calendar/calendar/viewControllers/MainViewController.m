//
//  MainViewController.m
//  calendar
//
//  Created by NextepMac on 12/17/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewCell.h"
#import "HeaderViewCell.h"
#import "CellData.h"
#import "SWRevealViewController.h"
#import "DayViewController.h"
#import "CalendarViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "AppSettings.h"
#import "SideCellData.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIImage *statusImage = [UIImage imageNamed:@"Untitled-20000.png"];
    [self.loader setImage:statusImage];
    
    
    //Add more images which will be used for the animation
    self.loader.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"Untitled-20000.png"],
                                         [UIImage imageNamed:@"Untitled-20001.png"],
                                         [UIImage imageNamed:@"Untitled-20002.png"],
                                         [UIImage imageNamed:@"Untitled-20003.png"],
                                         [UIImage imageNamed:@"Untitled-20004.png"],
                                         [UIImage imageNamed:@"Untitled-20005.png"],
                                         [UIImage imageNamed:@"Untitled-20006.png"],
                                         [UIImage imageNamed:@"Untitled-20007.png"],
                                   [UIImage imageNamed:@"Untitled-20008.png"],
                                   [UIImage imageNamed:@"Untitled-20009.png"],
                                   [UIImage imageNamed:@"Untitled-20010.png"],
                                   [UIImage imageNamed:@"Untitled-20011.png"],
                                   [UIImage imageNamed:@"Untitled-20012.png"],
                                   [UIImage imageNamed:@"Untitled-20013.png"],
                                   [UIImage imageNamed:@"Untitled-20014.png"],
                                   [UIImage imageNamed:@"Untitled-20015.png"],
                                   [UIImage imageNamed:@"Untitled-20016.png"],
                                   [UIImage imageNamed:@"Untitled-20017.png"],
                                   [UIImage imageNamed:@"Untitled-20018.png"],
                                   [UIImage imageNamed:@"Untitled-20019.png"],
                                   [UIImage imageNamed:@"Untitled-20020.png"],
                                   [UIImage imageNamed:@"Untitled-20021.png"],
                                   [UIImage imageNamed:@"Untitled-20022.png"],
                                   [UIImage imageNamed:@"Untitled-20023.png"],
                                   [UIImage imageNamed:@"Untitled-20024.png"],
                                   [UIImage imageNamed:@"Untitled-20025.png"],
                                   [UIImage imageNamed:@"Untitled-20026.png"],
                                   [UIImage imageNamed:@"Untitled-20027.png"],
                                   [UIImage imageNamed:@"Untitled-20028.png"],
                                   [UIImage imageNamed:@"Untitled-20029.png"],
                                   
                                         nil];
    
    
    //Start the animation
    [self.loader startAnimating];
    
    
    [self.defaultButton setHidden:YES];
    [self.defaultText setHidden:YES];
    [self.defaultTitle setHidden:YES];
    
    self.defaultButton.layer.cornerRadius = 5; // this value vary as per your desire
    self.defaultButton.clipsToBounds = YES;
    
    
    [self.defaultButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    isClicked = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.startUrl = @"http://nextep.ge/content/calendar/event/648x370/";
    
    NSString * firstUrlString = @"http://nextep.ge/calendar/getVersion";
    NSURL * firstUrl = [[NSURL alloc] initWithString:firstUrlString];
    
    NSString *urlAsString = @"http://nextep.ge/calendar/getDays";
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    NSString *urlAsStringCat = @"http://nextep.ge/calendar/getCategories";
    NSURL *urlCat = [[NSURL alloc] initWithString:urlAsStringCat];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"changeCategory"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"changeNotification"
                                               object:nil];

    
    arrDays = [[NSMutableArray alloc] init];
    arrMonth = [[NSMutableArray alloc] init];
    showCategories = [[NSMutableArray alloc] init];
    monthsNum = [[NSMutableDictionary alloc] initWithCapacity:12];
    AppSettings *appSettings = [AppSettings sharedInstance];
    appSettings.arrDay = [[NSMutableArray alloc] init];
    appSettings.arrMonth = [[NSMutableArray alloc] init];
    appSettings.arrCat = [[NSMutableArray alloc] init];
    
    
    [self addCategories];
    
    isOld = NO;
    
    self.parsedObject = [[NSDictionary alloc] init];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus != NotReachable) {
        NSData * dataUrl = [NSData dataWithContentsOfURL:firstUrl];
        NSError *localError = nil;
        NSDictionary * temp =[NSJSONSerialization JSONObjectWithData:dataUrl options:0 error:&localError];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *version;
        if([defaults objectForKey:@"version"] != nil)
            version = [[defaults objectForKey:@"version"] mutableCopy];
        
        if(temp != nil){
            NSString * ver = temp[@"Data"];
            if([version isEqual:ver])
                isOld = YES;
            else{
                [defaults setObject:ver forKey:@"version"];

            }
        }

        if(!isOld){
            [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
                if(data != nil){
                    self.allDaysData = data;
                    [self parseJson:data];
                    [self parseData];
                }
        
            }];
            [AppDelegate downloadDataFromURL:urlCat withCompletionHandler:^(NSData *data) {
                if(data != nil){
                    [self parseJsonCat:data];
                    [self parseDataCat];
                }
            }];
        }
        else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.parsedObject = [defaults objectForKey:@"allData"];
            [self parseData];
            self.parsedObjectCat = [defaults objectForKey:@"allCat"];
            [self parseDataCat];

        }
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.parsedObject = [defaults objectForKey:@"allData"];
        [self parseData];
        self.parsedObjectCat = [defaults objectForKey:@"allCat"];
        [self parseDataCat];
    }
    
    self.dayTitle.numberOfLines = 3;
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
        
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)createNotifications{
    int i = 0;
    AppSettings *appSettings = [AppSettings sharedInstance];
    appSettings.array = [[NSMutableArray alloc] init];

    
    while(true){
        CellData * temp;
        if(i == 7)
            break;
        if([arrDays count] > (curIndex + i)){
            temp = [arrDays objectAtIndex:(curIndex + i)];
        }
        else{
            temp = [arrDays objectAtIndex:(curIndex + i - [arrDays count])];
        }
        i++;
        [appSettings.array addObject:temp];
        
    }
}


- (void)addCategories{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"categories"] != nil){
        showCategories = [[defaults objectForKey:@"categories"] mutableCopy];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.revealViewController.panGestureRecognizer.enabled = YES;
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    AppSettings *appSettings = [AppSettings sharedInstance];
    if ([[notification name] isEqualToString:@"changeCategory"]){
        [arrDays removeAllObjects];
        [arrMonth removeAllObjects];
        [notEmpty removeAllObjects];
        [monthsNum removeAllObjects];
        [self addCategories];
        [self parseData];
        [appSettings.array removeAllObjects];
    }
    if ([[notification name] isEqualToString:@"changeNotification"]){
        NSString * notificationOn;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"notification"] != nil)
            notificationOn = [defaults objectForKey:@"notification"];
        else
            notificationOn = @"0";
        if([notificationOn isEqual:@"0"]){
            
            [appSettings.array removeAllObjects];

        }
        else
            [self createNotifications];
    }
}

- (void)parseJsonCat:(NSData *)data{
    
    NSError *localError = nil;
    self.parsedObjectCat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSError * error = localError;
        NSLog(@"%@", error);
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.parsedObjectCat forKey:@"allCat"];
    
}



- (void)parseJson:(NSData *)data{
    
    NSError *localError = nil;
    self.parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSError * error = localError;
        NSLog(@"%@", error);
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.parsedObject forKey:@"allData"];
    
}
- (void)parseDataCat{
    AppSettings *appSettings = [AppSettings sharedInstance];
    NSMutableArray * arCat = [[NSMutableArray alloc] init];
    NSArray * categories = self.parsedObjectCat[@"Data"];
    for(int i = 0; i < [categories count]; i++){
        NSDictionary * temp = [categories objectAtIndex:i];
        SideCellData * data = [SideCellData alloc];
        data.cId = temp[@"Id"];
        data.text = temp[@"Name"];
        data.image = temp[@"ImageId"];
        [arCat addObject:data];
    }
    appSettings.arrCat = arCat;
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
                if([arrMonth count] != monthIndex - 1){
                    for(int i = (int)([arrMonth count] - 1); i < monthIndex - 2; i++){
                        [arrMonth addObject:@"0"];
                    }
                }
                [arrMonth insertObject:[NSString stringWithFormat:@"%d",numInMonth] atIndex:(monthIndex - 1)];
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
            
            [arrDays addObject:dayData];
        }
        
    }
    
    if([((CellData *)arrDays.lastObject).month intValue] != [arrMonth count] || numInMonth != 1){
        for(int i = (int)([arrMonth count] - 1); i < monthIndex - 2; i++){
            [arrMonth addObject:@"0"];
        }

        [arrMonth insertObject:[NSString stringWithFormat:@"%d",numInMonth] atIndex:(monthIndex - 1)];
    }
    
    appSettings.arrMonth = arrMonth;
    appSettings.arrDay = arrDays;
    
    
    notEmpty = [[NSMutableArray alloc] init];
    sectionNumber = 0;
    for(int i = 0; i < [arrMonth count]; i++){
        if(![[arrMonth objectAtIndex:i] isEqualToString:@"0"]){
            [notEmpty addObject:[arrMonth objectAtIndex:i]];
            [monthsNum setObject:[NSString stringWithFormat:@"%d", i] forKey:[NSString stringWithFormat:@"%d", sectionNumber]];
            sectionNumber++;
        }
    }
    sections = sectionNumber;
    
    [self setMainValues];
    
    [self.table reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self scrollToPosition];
        [self createNotifications];

    });
    
    
    
}

- (void)scrollToPosition{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    [df setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [df dateFromString:[NSString stringWithFormat:@"%@-%@-%@", self.currentData.day, self.currentData.month, self.currentData.year]];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:date options:0];
    NSCalendar *calendars = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendars components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nextDate];
    
    
    NSIndexPath *indexPath;
    int months = [comps month];
    int day = [comps day];
    int row = 0;
    int index = 0;
    int section = 0;
    int j = 0;
    if([arrMonth count] > (months - 1)){
        int numInMonth = [[arrMonth objectAtIndex:(months - 1)] intValue];
        
        
        for(int i = 0; i < (months - 1); i++){
            if([[arrMonth objectAtIndex:i] intValue] != 0)
                section ++;
            index += [[arrMonth objectAtIndex:i] intValue];
        }
        
        for(j = index; j < (index + numInMonth + 1); j++){
            if([arrDays count] > j){
                CellData * temp = [arrDays objectAtIndex:j];
                
                if([temp.number intValue] == day || [temp.number intValue] > day){
                    break;
                }
                if([[self changeMonth:temp.month] intValue] > months){
                    row = 0;
                    break;
                }
                row ++;
            }
            
        }
    }
    
    curIndex = j;
    if(section != 0 || row != 0){
        
        indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
        [self.table scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
    }

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



- (void)setMainValues{
    [self.topColor setBackgroundColor:[UIColor colorWithRed:118.0/255.0 green:55.0/255.0 blue:116.0/255.0 alpha:0.9]];
    UIImage * imageBox = [UIImage imageNamed:@"day.png"];
    [self.dayBox setImage:imageBox];
    self.dayBox.layer.cornerRadius = 15;
    self.dayBox.layer.masksToBounds = YES;
    
    NSDate * now = [NSDate date];
    NSCalendar *calendars = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendars components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    NSInteger day = [comps day];
    NSInteger months = [comps month];
    //   int index = [self getNumberOfObjects:(((int)[comps month]) - 1)] + (int)[comps day] - 1;
    
    CellData * current = [CellData alloc];
    if([arrMonth count] > (months - 1)){
        int numInMonth = [[arrMonth objectAtIndex:(months - 1)] intValue];
        if(numInMonth != 0){
            int index = 0;
            for(int i = 0; i < (months - 1); i++){
                index += [[arrMonth objectAtIndex:i] intValue];
            }
            int j = index - 1;
            if(j < 0)
                j = 0;
            for(j; j < (index + numInMonth); j++){
                if([arrDays count] > j){
                    CellData * temp = [arrDays objectAtIndex:j];
                    if([temp.number intValue] == day){
                        current = temp;
                        break;
                    }
                }
            }
        }
    }
    
    [self.topDate setText:[NSString stringWithFormat:@"%d", (int)day]];
    [self.month setText:[self changeIntToMonth:months]];
    
    DayData * data = [DayData alloc];
    data.day = [NSString stringWithFormat:@"%ld", (long)[comps day]];
    data.month = [NSString stringWithFormat:@"%ld", (long)[comps month]];
    data.year  = [NSString stringWithFormat:@"%ld", (long)[comps year]];
    self.currentData = data;
    
    
    if([current.number intValue] == day){
        
        [self.dayTitle setText:((EventData *)[current.events objectAtIndex:0]).name];
        
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", self.startUrl, ((EventData *)[current.events objectAtIndex:0]).image]]]];
        [self.back setImage:image];
        
        [self.topColor setHidden:NO];
        [self.dayTitle setHidden:NO];
        [self.defaultButton setHidden:YES];
        [self.defaultText setHidden:YES];
        [self.defaultTitle setHidden:YES];
        isClicked = NO;
        
    }
    else{
        UIImage *image = [UIImage imageNamed:@"default.png"];
        [self.back setImage:image];
        [self.topColor setHidden:YES];
        [self.dayTitle setHidden:YES];
        [self.defaultButton setHidden:NO];
        [self.defaultText setHidden:NO];
        [self.defaultTitle setHidden:NO];
        isClicked = NO;
    }
}


- (void)scrollDown
{
    
    NSIndexSet * indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionNumber, sections)];
    sectionNumber += sections;
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
    return [[notEmpty objectAtIndex:(section%sections)] intValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *simpleTableIdentifier = @"HeaderViewCell";
    HeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    [cell setCellData:[self changeIntToMonth:[[monthsNum objectForKey:[NSString stringWithFormat:@"%d", ((int)section%sections)]]intValue] + 1]];
    
    return [cell contentView];
}

- (int)getNumberOfObjects:(int)section{
    int sum = 0;
    for(int i = 0; i < section; i++){
        if([notEmpty count] > i)
            sum += [[notEmpty objectAtIndex:i] intValue];
    }
    return sum;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MainViewCell";
    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    int num = [self getNumberOfObjects:((int)indexPath.section%sections)];
    CellData *data = [arrDays objectAtIndex:indexPath.row + num];
    cell.month = data.month;
    [cell setCellData:data];
    
    if(!data.isWork){
        [cell.circle setHidden:NO];
        cell.circle.layer.cornerRadius = 5;
    }
    else
        [cell.circle setHidden:YES];
    
    if((indexPath.section%sections) == (sections - 1) && indexPath.row == ([[notEmpty objectAtIndex:indexPath.section%sections] intValue] - 1)){
        if(indexPath.section == (sectionNumber - 1)){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollDown];
            });
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loader stopAnimating];
            [self.loader setHidden:YES];
         //   [self.activityIndicator stopAnimating];
            
        });
        
    

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
    NSString * months = cell.month;
    [self.month setText:months];
    NSString * titles = cell.title.text;
    [self.dayTitle setText:titles];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    int k =([[notEmpty objectAtIndex:indexPath.section%sections] intValue] - 1);
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
    
    if(!isClicked){
        [self.topColor setHidden:NO];
        [self.dayTitle setHidden:NO];
        [self.defaultButton setHidden:YES];
        [self.defaultText setHidden:YES];
        [self.defaultTitle setHidden:YES];
        isClicked = YES;
    }
    
    CellData * temp = [arrDays objectAtIndex:([self getNumberOfObjects:indexPath.section%sections] + indexPath.row)];
    
    
    //  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", self.startUrl, ((EventData *)[temp.events objectAtIndex:0]).image]]]];
    UIImage * image = [UIImage imageNamed:@"back.png"];
    [self.back setImage:image];
    
    
    if(section < sectionNumber)
        [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"view_day"])
    {
        DayViewController * controller = [segue destinationViewController];
        controller.currentData = self.currentData;
        
    }
   

}



-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}





@end
