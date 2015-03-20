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


@interface DayViewController () 


@end


@implementation DayViewController
@synthesize topColor, back, calendar, sidebarButton, backMain, previous;


- (void)viewDidLoad
{
    [super viewDidLoad];
    show = NO;
    
    self.defButton.layer.cornerRadius = 5; // this value vary as per your desire
    self.defButton.clipsToBounds = YES;
    
    [self.defButton addTarget:self.revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
 //   [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    self.revealViewController.panGestureRecognizer.enabled = NO;
    
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
    
    self.scrollDays = [[ScrollDayView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, 100)];
    [self.scrollDays startDate:self.currentData];
    [self.scrollDays addDays];
    [self.view addSubview:self.scrollDays];
}

- (void) setEvents{
    
    CellData * cur = [CellData alloc];
    int months = [self.curMonth intValue];
    int day = [self.curDate intValue];
    if([self.allMonth count] > months){
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
/*
    int index = 0;
    for(int i = 0; i < ([self.curMonth intValue] - 1); i++){
        index += [[self.allMonth objectAtIndex:i] intValue];
    }
    
    index = index + [self.curDate intValue] - 1;
    
    CellData * cur = nil;
    if([self.allDays count] > index)
        cur = [self.allMonth objectAtIndex:index]; */
    self.allEvents = cur.events;
    for(int i = 0; i < [cur.events count]; i++){
       [textViews insertObject:[NSNumber numberWithFloat:[self textViewHeightForAttributedText:((EventData *)[cur.events objectAtIndex:i]).eventDescription andWidth:(self.view.bounds.size.width - 40)]] atIndex:i];
    }
    UIImage * image;
    if([cur.events count] == 0){
    //    UILabel * defTitle = [[UILabel alloc] init];
    //    [defTitle setText:@"დღე ცარიელია"];
    //    [defTitle setFont:[UIFont systemFontOfSize:18.0]];
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
    UIImage * img = [UIImage imageNamed:@"icon.png"];
/*    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
 //   params.link = [NSURL URLWithString:@"http://nextep.ge/doYouBelieveMe/about"];
    params.name = temp.name;
    params.caption = [NSString stringWithFormat:@"გილოცავთ! დღეს არის %@", temp.name];
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithParams:params clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              NSLog(@"result %@", results);
                                          }
                                      }]; */
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
    

  /*  } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
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
    } */
}




-(void)enableViewContent:(BOOL)enable{
    [self.scrollDays enableScroll:enable];
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
        calendarView.allDays = self.allDays;
        calendarView.allMonth = self.allMonth;
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
