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
#import "CategoryViewCell.h"
#import "AppSettings.h"
#import "SideCellData.h"


@implementation CalendarViewController
@synthesize menu, content, calendar, buttonSideBar, top, table, delegate;

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.parsedObject = [defaults objectForKey:@"allData"];
    
    AppSettings *appSettings = [AppSettings sharedInstance];
    self.allMonth = appSettings.arrMonth;
    self.allDays = appSettings.arrDay;
    self.lastDate = [[NSDate alloc] init];
    
    arr = [[NSMutableArray alloc] init];
    headers = [[NSMutableArray alloc] init];
    data = [[NSMutableArray alloc] init];
    textViews = [[NSMutableArray alloc] init];
    showCategories = [[NSMutableArray alloc] init];
    
    [self setData:[NSDate date]];
    [self addCategories];
    
    [self.buttonSideBar addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
   
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.calendar = [[JTCalendar alloc]init];
    [self.calendar setMenuMonthsView:self.menu];
    [self.calendar setContentView:self.content];
    [self.calendar setDataSource:self];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"changeCategory"
                                               object:nil];

    
    
    [self.top setBackgroundColor:[UIColor colorWithRed:80.0/255.0 green:172.0/255.0 blue:202.0/255.0 alpha:1]];
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
        [self.allMonth removeAllObjects];
        [self addCategories];
        [self parseData];
        [appSettings.array removeAllObjects];
        [arr removeAllObjects];
        [headers removeAllObjects];
        [data removeAllObjects];
        [self.calendar reloadAppearance];
        [self setData:self.lastDate];
        [self.table reloadData];
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


-(void)enableViewContent:(BOOL)enable{
    [self.calendar enableViewContent:enable];
    self.table.userInteractionEnabled = enable;
    self.revealViewController.panGestureRecognizer.enabled = !enable;
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
    int numInMonth = 0;
    if([self.allMonth count] > (month - 1))
        numInMonth = [[self.allMonth objectAtIndex:(month - 1)] intValue];
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
    self.lastDate = date;
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
                return 46.0;
            return 46.0;
        }
        else
            if(indexPath.section == 0)
                return 60.0;
            return [[textViews objectAtIndex:indexPath.section - 1] floatValue] + 15;
    }
    else
        return 46.0;
}

- (UIColor *)getColor:(NSString *)cId{
    if([cId isEqual:@"1"])
        return [UIColor colorWithRed:222.0/255.0 green:58.0/255.0 blue:149.0/255.0 alpha:1.0];
    else if([cId isEqual:@"3"])
        
        return [UIColor colorWithRed:255.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    else if([cId isEqual:@"6"])
        return [UIColor colorWithRed:30.0/255.0 green:47.0/255.0 blue:144.0/255.0 alpha:1.0];
    else if([cId isEqual:@"102"])
        return [UIColor colorWithRed:0.0/255.0 green:132.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    
    return nil;
}

- (NSString *)getName:(NSString *)cId{
    AppSettings *appSettings = [AppSettings sharedInstance];
    for(int i = 0; i < [appSettings.arrCat count]; i++){
        SideCellData * temp = [SideCellData alloc];
        temp = [appSettings.arrCat objectAtIndex:i];
        if([temp.cId intValue] == [cId intValue])
            return temp.text;
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        if(indexPath.section == 0){
            static NSString *CellIdentifier = @"HeaderCategoryViewCell";
            HeaderCategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
            NSArray *viewsToRemove = [cell.circles subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }

            for(int i = 0; i < [showCategories count] + 1; i++){
                UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(i * 15,13,10,10)];
                circleView.layer.cornerRadius = 5;
                if(i == 0)
                    circleView.backgroundColor = [self getColor:@"3"];
                else
                    circleView.backgroundColor = [self getColor:[showCategories objectAtIndex:i - 1]];
                [cell.circles addSubview:circleView];
            }
            if(![[arr objectAtIndex:indexPath.section] boolValue])
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            if(indexPath.section == 0){
                static NSString *CellIdentifier = @"CategoryViewCell";
                CategoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
                NSArray *viewsToRemove = [cell.textView subviews];
                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }

                int j = 1;
                UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(24,15,10,10)];
                circleView.layer.cornerRadius = 5;
                circleView.backgroundColor = [self getColor:@"3"];
                [cell.textView addSubview:circleView];
                UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, 150, 15)];
                [lab setFont:[UIFont systemFontOfSize:10.0]];
                [lab setText:[self getName:@"3"]];
                [cell.textView addSubview:lab];
                if([showCategories containsObject:@"102"]){
                    j++;
                    UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(145,15,10,10)];
                    circleView.layer.cornerRadius = 5;
                    circleView.backgroundColor = [self getColor:@"102"];
                    [cell.textView addSubview:circleView];
                    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(160, 13, 150, 15)];
                    [lab setFont:[UIFont systemFontOfSize:10.0]];
                    [lab setText:[self getName:@"102"]];
                    [cell.textView addSubview:lab];

                }
                if([showCategories containsObject:@"1"]){
                    CGFloat x1;
                    CGFloat y1;
                    CGFloat x2;
                    CGFloat y2;
                    if(j == 2){
                        x1 = 24;
                        y1 = 30;
                        x2 = 40;
                        y2 = 28;
                    }else{
                        x1 = 145;
                        y1 = 15;
                        x2 = 160;
                        y2 = 13;
                    }
                    UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(x1,y1,10,10)];
                    circleView.layer.cornerRadius = 5;
                    circleView.backgroundColor = [self getColor:@"1"];
                    [cell.textView addSubview:circleView];
                    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(x2, y2, 150, 15)];
                    [lab setFont:[UIFont systemFontOfSize:10.0]];
                    [lab setText:[self getName:@"1"]];
                    [cell.textView addSubview:lab];
                    
                    j++;
                }
                if([showCategories containsObject:@"6"]){
                    CGFloat x1;
                    CGFloat y1;
                    CGFloat x2;
                    CGFloat y2;
                    if(j == 2){
                        x1 = 24;
                        y1 = 30;
                        x2 = 40;
                        y2 = 28;
                    }else if(j == 1){
                        x1 = 145;
                        y1 = 15;
                        x2 = 160;
                        y2 = 13;
                    }
                    else if(j == 3){
                        x1 = 145;
                        y1 = 30;
                        x2 = 160;
                        y2 = 28;
                    }
                    UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(x1,y1,10,10)];
                    circleView.layer.cornerRadius = 5;
                    circleView.backgroundColor = [self getColor:@"6"];
                    [cell.textView addSubview:circleView];
                    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(x2, y2, 150, 15)];
                    [lab setFont:[UIFont systemFontOfSize:10.0]];
                    [lab setText:[self getName:@"6"]];
                    [cell.textView addSubview:lab];
                
                }


                return cell;
            }
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
