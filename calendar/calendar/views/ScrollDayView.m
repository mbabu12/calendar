//
//  ScrollDayView.m
//  calendar
//
//  Created by NextepMac on 2/13/15.
//  Copyright (c) 2015 NextepMac. All rights reserved.
//

#import "ScrollDayView.h"

@implementation ScrollDayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)myInitialization
{
    //do your stuff
    CGRect viewFrame = self.frame;
    width = 40;
    widthBig = 100;
    y = 20;
    bigY = -y - (y/2);
    x = (viewFrame.size.width - 4 * width - widthBig)/6;
    arrDays = [[NSMutableArray alloc] init];

    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeleft];
   
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swiperight];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       [self myInitialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self myInitialization];
    }
    return self;
}

- (void)startDate:(DayData *)data{
    
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", data.day, data.month, data.year];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    
    self.startData = dateFromString;
    
}


- (NSDate *)getCurDate{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 3;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:minDate options:0];
    
    return nextDate;
}

- (void)changeDateToLeft:(UIView *)view{
    UILabel *label = (UILabel *)[view viewWithTag:1];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:minDate options:0];
    
    dayComponent.day = 1;
    NSDate *temp = [theCalendar dateByAddingComponents:dayComponent toDate:minDate options:0];
    minDate = temp;
    maxDate = nextDate;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nextDate];
    
    [label setText:[@([components day]) stringValue]];

}

- (void)changeDateToRight:(UIView *)view{
    UILabel *label = (UILabel *)[view viewWithTag:1];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -7;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:maxDate options:0];
    
    dayComponent.day = -1;
    NSDate *temp = [theCalendar dateByAddingComponents:dayComponent toDate:maxDate options:0];
    maxDate = temp;
    minDate = nextDate;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nextDate];
    
    [label setText:[@([components day]) stringValue]];


}


-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    UIView * temp = [arrDays objectAtIndex:0];
    CGRect f = temp.frame;
    f.origin.x = self.bounds.size.width;
    temp.frame = f;
    [self changeDateToLeft:temp];
    [arrDays removeObjectAtIndex:0];
    [arrDays insertObject:temp atIndex:6];
    
    
    for(int j = 0; j < 6; j++){
        float alphaLabel = 0;
        float point = 0;
        float alph = 0.6;
        
        temp = [arrDays objectAtIndex:j];
        f = temp.frame;
        if(j == 2){
            f.size.width = width;
            f.size.height = width;
            f.origin.x = f.origin.x - (x + width);
            f.origin.y = y;
            point = 0.4;
            alph = 0.6;
        }
            
        else if(j == 3){
            f.size.width = widthBig;
            f.size.height = widthBig;
            f.origin.x = f.origin.x - (x + widthBig);
            f.origin.y = bigY;
            UILabel * labMonth = (UILabel *)[temp viewWithTag:2];
            point = 1;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self getCurDate]];
            
            [labMonth setText:[self getMonth:[components month]]];
            alph = 1;
            alphaLabel = 1;
        }
        else
            f.origin.x = f.origin.x - (x + width);
            
        [UIView animateWithDuration:0.2
                                delay:0.05
                            options: UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                if(j == 3 || j ==2){
                                    temp.transform = CGAffineTransformScale(CGAffineTransformIdentity, point, point);
                                    UILabel * labMonth = (UILabel *)[temp viewWithTag:2];
                                    labMonth.alpha = alphaLabel;
                                }
                                temp.frame = f;
                                temp.alpha = alph;
                                
                            }
                            completion:^(BOOL finished){
                            }];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"dayChanged"
     object:self];

}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    UIView * temp = [arrDays objectAtIndex:6];
    CGRect f = temp.frame;
    f.origin.x = -width;
    temp.frame = f;
    [arrDays removeObjectAtIndex:6];
    [self changeDateToRight:temp];
    [arrDays insertObject:temp atIndex:0];
    
    for(int j = 6; j > 0; j--){
        temp = [arrDays objectAtIndex:j];
        f = temp.frame;
        
        float point = 0;
        float alphaLabel = 0;
        float alph = 0.6;
        if(j == 4){
            f.size.width = width;
            f.size.height = width;
            f.origin.x = f.origin.x + (x + widthBig);
            f.origin.y = y;
            point = 0.4;
            alph = 0.6;
        }
        else if(j == 3){
            f.size.width = widthBig;
            f.size.height = widthBig;
            f.origin.x = f.origin.x + (x + width);
            f.origin.y = bigY;
            point = 1;
            UILabel * labMonth = (UILabel *)[temp viewWithTag:2];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[self getCurDate]];
            
            [labMonth setText:[self getMonth:[components month]]];
            alphaLabel = 1;
            alph = 1;
        }
                
        else
            f.origin.x = f.origin.x + (x + width);
            
            [UIView animateWithDuration:0.2
                                delay:0.05
                            options: UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                if(j == 3 || j ==4){
                                    temp.transform = CGAffineTransformScale(CGAffineTransformIdentity, point, point);
                                    UILabel * labMonth = (UILabel *)[temp viewWithTag:2];
                                    labMonth.alpha = alphaLabel;
                                }
                                
                                temp.frame = f;
                                temp.alpha = alph;
                               }
                            completion:^(BOOL finished){
        
                            }];
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"dayChanged"
     object:self];
}

- (NSString *)getMonth:(NSInteger)value{
    if(value == 1){
        return @"იანვარი";
    }
    else if(value == 2){
        return @"თებერვალი";
    }
    else if(value == 3){
        return @"მარტი";
    }
    else if(value == 4){
        return @"აპრილი";
    }
    else if(value == 5){
        return @"მაისი";
    }
    else if(value == 6){
        return @"ივნისი";
    }
    else if(value == 7){
        return @"ივლისი";
    }
    else if(value == 8){
        return @"აგვისტო";
    }
    else if(value == 9){
        return @"სექტემბერი";
    }
    else if(value == 10){
        return @"ოქტომბერი";
    }
    else if(value == 11){
        return @"ნოემბერი";
    }
    else if(value == 12){
        return @"დეკემბერი";
    }
    return 0;
}


- (void)addDays{
    for(int i = 0; i < 7; i++){
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = i - 3;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:self.startData options:0];

        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:nextDate];
        
        if(i == 0)
            minDate = nextDate;
        else if(i == 6)
            maxDate = nextDate;
        
        UIView * day = [[UIView alloc] init];
        [day setBackgroundColor:[UIColor whiteColor]];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, widthBig, widthBig)];
        UILabel * monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, widthBig - 25, widthBig, 20)];
   
        monthLabel.alpha = 0;
        [monthLabel setFont:[UIFont systemFontOfSize:14]];
        day.layer.anchorPoint = CGPointMake(0.5, 0.5);
        day.frame = CGRectMake((x + width) * i  - width, bigY, widthBig, widthBig);
        [label setFont:[UIFont systemFontOfSize:40]];
        
        if(i == 3){
            monthLabel.alpha  = 1;
            [monthLabel setText:[self getMonth:[components month]]];
        }
        else if(i > 3){
            day.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            CGRect f = day.frame;
            f.origin.x = (x + width) * (i - 1) + (x + widthBig)  - width;
            f.origin.y = y;
            day.frame = f;
            day.alpha = 0.6;
            width = f.size.width;
            
        }
        else{
            day.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.4, 0.4);
            CGRect f = day.frame;
            f.origin.x = (x + width) * i  - width;
            f.origin.y = y;
            day.frame = f;
            day.alpha = 0.6;
        }
        
        day.layer.cornerRadius = 10;
        day.layer.masksToBounds = YES;
        
        [label setText:[@([components day]) stringValue]];
        label.textAlignment = NSTextAlignmentCenter;
        monthLabel.textAlignment = NSTextAlignmentCenter;
        monthLabel.tag = 2;
        label.tag = 1;
 
        [day addSubview:label];
        [day addSubview:monthLabel];
        [arrDays addObject:day];
        [self addSubview:day];
    }
}


@end
