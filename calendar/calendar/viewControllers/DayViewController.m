//
//  DayViewController.m
//  calendar
//
//  Created by NextepMac on 12/22/14.
//  Copyright (c) 2014 NextepMac. All rights reserved.
//

#import "DayViewController.h"



@interface DayViewController () <UIActionSheetDelegate>

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;


@end


@implementation DayViewController
@synthesize topColor, back, calendar, sidebarButton, backMain, previous;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
 //       self.curDate = self.currentData.day;
  //      [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  
    if ((self = [super initWithCoder:aDecoder]))
    {
       
    //    self.curDate = self.currentData.day;
   //     [self setUp];
        
    }
    return self;
}




#pragma mark -
#pragma mark View lifecycle





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.previous = @"";
    self.curDate = self.currentData.day;
    self.curMonth = self.currentData.month;
    self.curYear = self.currentData.year;
    [self setUp];
    
    [self setValues];
    [self.topColor setHidden:NO];
    
    
    [_carousel startAll];
    _carousel.type = iCarouselTypeCoverFlow2;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    
   
}

- (IBAction)viewCal:(id)sender {
    [self performSegueWithIdentifier:@"view_cal2" sender:nil];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"TestNotification"]){
        NSArray * arrVisible = self.carousel.visibleItemViews;
        UIView * prev1 = [arrVisible objectAtIndex:3];
        [prev1 setBackgroundColor:[UIColor whiteColor]];
        prev1.alpha = 0.6;
        UILabel *myLabel1 = (UILabel *)[prev1 viewWithTag:2];
        [myLabel1 setText:@""];
        UIView * prev2 = [arrVisible objectAtIndex:1];
        [prev2 setBackgroundColor:[UIColor whiteColor]];
        prev2.alpha = 0.6;
        UILabel *myLabel2 = (UILabel *)[prev2 viewWithTag:2];
        [myLabel2 setText:@""];
        UIView * currentView = [arrVisible objectAtIndex:2];
        UILabel *myLabel = (UILabel *)[currentView viewWithTag:2];
        
        if(currentView.tag == 11)
            [myLabel setText:@"იანვარი"];
        else if(currentView.tag == 12)
            [myLabel setText:@"თებერვალი"];
        else if(currentView.tag == 13)
            [myLabel setText:@"მარტი"];
        else if(currentView.tag == 14)
            [myLabel setText:@"აპრილი"];
        else if(currentView.tag == 15)
            [myLabel setText:@"მაისი"];
        else if(currentView.tag == 16)
            [myLabel setText:@"ივნისი"];
        else if(currentView.tag == 17)
            [myLabel setText:@"ივლისი"];
        else if(currentView.tag == 18)
            [myLabel setText:@"აგვისტო"];
        else if(currentView.tag == 19)
            [myLabel setText:@"სექტემბერი"];
        else if(currentView.tag == 20)
            [myLabel setText:@"ოქტომბერი"];
        else if(currentView.tag == 21)
            [myLabel setText:@"ნოემბერი"];
        else if(currentView.tag == 22)
            [myLabel setText:@"დეკემბერი"];

        
        currentView.alpha = 1;
        UIImage * image = [UIImage imageNamed:@"day.png"];
        CGRect rect = CGRectMake(0,0,currentView.bounds.size.width,currentView.bounds.size.height);
        UIGraphicsBeginImageContext( rect.size );
        [image drawInRect:rect];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(picture1);
        UIImage *img=[UIImage imageWithData:imageData];
        
        [currentView setBackgroundColor:[UIColor colorWithPatternImage:img]];
        int year = [self.curYear intValue];
        int cYear = year;
     
        UILabel *label = (UILabel *)[currentView viewWithTag:1];
        NSString * number = [label text];
        if((currentView.tag == 22) & [number isEqualToString:@"31"]){
            if([previous isEqualToString:@"1"]){
                year--;
                self.curYear = [@(year) stringValue];
                if(cYear % 4 == 0){
                    [_carousel reloadData];
                    valueDate--;
                }
                if(cYear % 4 == 1){
                    [_carousel reloadData];
                    valueDate++;
                }
            }
        }
        else if((currentView.tag == 11) & [number isEqualToString:@"1"]){
            if([previous isEqualToString:@"31"]){
                year++;
                self.curYear = [@(year) stringValue];
                if(cYear % 4 == 0){
                    [_carousel reloadData];
                    valueDate--;
                }
                if(cYear % 4 == 3){
                    [_carousel reloadData];
                    valueDate++;
                }
            }

        }
        previous = number;
        
    }
}


- (void)setUp
{
    //set up data
    _wrap = YES;
    self.items = [NSMutableArray array];
    valueDate = 0;
    int year = [self.curYear intValue];
    if(year%4 == 0)
        valueDate = 366;
    else
        valueDate = 365;
    for (int i = 0; i < valueDate; i++)
    {
        [_items addObject:@(i)];
    }
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark UIActionSheet methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex	>= 0)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        
        //carousel can smoothly animate between types
        [UIView beginAnimations:nil context:nil];
        _carousel.type = type;
        
        [UIView commitAnimations];
        
        
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    int n = [self.curDate intValue];
    int year = [self.curYear intValue];
    int month = 0;
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.alpha = 0.6;
        view.layer.cornerRadius = 15;
        view.layer.masksToBounds = YES;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:30];
        label.tag = 1;
        [view addSubview:label];
        
        UILabel * monthLabel = [[UILabel alloc] init];
        monthLabel.tag = 2;
        [monthLabel setText:@""];
        monthLabel.textAlignment = NSTextAlignmentCenter;
        [monthLabel setFont:[UIFont systemFontOfSize:10]];
        monthLabel.frame = CGRectMake(0, 40, 75, 30);
        [view addSubview:monthLabel];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    if([self.curMonth isEqual:@"იანვარი"])
        month = 1;
    else if([self.curMonth isEqual:@"თებერვალი"])
        month = 2;
    else if([self.curMonth isEqual:@"მარტი"])
        month = 3;
    else if([self.curMonth isEqual:@"აპრილი"])
        month = 4;
    else if([self.curMonth isEqual:@"მაისი"])
        month = 5;
    else if([self.curMonth isEqual:@"ივნისი"])
        month = 6;
    else if([self.curMonth isEqual:@"ივლისი"])
        month = 7;
    else if([self.curMonth isEqual:@"აგვისტო"])
        month = 8;
    else if([self.curMonth isEqual:@"სექტემბერი"])
        month = 9;
    else if([self.curMonth isEqual:@"ოქტომბერი"])
        month = 10;
    else if([self.curMonth isEqual:@"ნოემბერი"])
        month = 11;
    else if([self.curMonth isEqual:@"დეკემბერი"])
        month = 12;
    
    
    int i = [_items[index] intValue];
    
    NSDate * date = [NSDate alloc];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:n];
    [comps setMonth:month];
    [comps setYear:year];
    date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    NSDate *startDate = [NSDate date];
    [comps setDay:31];
    [comps setMonth:12];
    [comps setYear:year - 1];
    startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:date
                                                         options:0];
    int days = (int)components.day;
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    NSCalendar *calendars = [NSCalendar currentCalendar];
    NSDate *changeDays = [NSDate alloc];
    if((days + i) <= valueDate){
        dayComponent.day = i;
        changeDays = [calendars dateByAddingComponents:dayComponent toDate:date options:0];
    }
    else{
        dayComponent.day = (days + i)%valueDate;
        changeDays = [calendars dateByAddingComponents:dayComponent toDate:startDate options:0];
    }
    
    NSDateComponents * componentsDate = [calendars components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:changeDays]; // Get necessary date components

    label.text = [@([componentsDate day]) stringValue];
    view.tag = [componentsDate month] + 10;
    
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return _wrap;
        }
            
        case iCarouselOptionTilt:
        {
            return 0;
        }
        case iCarouselOptionSpacing:
        {
            //  CGFloat k =value * _spacingSlider.value;
            return 2;
        }
        default:
        {
            return value;
        }
    }
}



@end
