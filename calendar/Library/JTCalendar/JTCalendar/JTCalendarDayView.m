//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"
#import <QuartzCore/QuartzCore.h>
#import "JTCircleView.h"
#import "AppSettings.h"
#import "CellData.h"
#import "EventData.h"

@interface JTCalendarDayView (){
    JTCircleView *circleView;
    
    JTCircleView *dotView;
    
    BOOL isSelected;
    
    int cacheIsToday;
    NSString *cacheCurrentDateText;
}
@end

static NSString *kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendarDayView
@synthesize textLabel, isWeekend;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)changeWeek{
    isWeekend = YES;
}

- (void)commonInit
{
    isSelected = NO;
    isWeekend = NO;
    self.isOtherMonth = NO;
    
    
    {
        circleView = [JTCircleView new];
        [self addSubview:circleView];
    }
    
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
    }
    
    {
        dotView = [JTCircleView new];
        [self addSubview:dotView];
        dotView.hidden = YES;
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kJTCalendarDaySelected object:nil];
    }
    self.layer.borderColor = [UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 0.45f;
    
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    circleView.layer.cornerRadius = sizeCircle / 2.;
    
    dotView.frame = CGRectMake(0, 0, sizeDot, sizeDot);
    dotView.center = CGPointMake(self.frame.size.width / 2., (self.frame.size.height / 2.) + sizeDot * 2.5);
    dotView.layer.cornerRadius = sizeDot / 2.;
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    self->_date = date;
    
    NSString * dateText = [dateFormatter stringFromDate:date];
    NSString *theCharacter = [NSString stringWithFormat:@"%c", [dateText characterAtIndex:0]];
    if([theCharacter isEqualToString:@"0"])
        dateText = [dateText substringWithRange:NSMakeRange(1, 1)];
        
    textLabel.text = dateText;
    
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
    
    [self setEvents:date];
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

- (void)setEvents:(NSDate *)curDate{
    AppSettings *appSettings = [AppSettings sharedInstance];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:curDate];
    CellData * cur = [CellData alloc];
    int months = [components month];
    int day = [components day];
    if([appSettings.arrMonth count] > (months - 1)){
        int numInMonth = [[appSettings.arrMonth objectAtIndex:(months - 1)] intValue];
        if(numInMonth != 0){
            int index = 0;
            for(int i = 0; i < (months - 1); i++){
                index += [[appSettings.arrMonth objectAtIndex:i] intValue];
            }
            int j = index - 1;
            if(j < 0)
                j = 0;
            for(j; j < (index + numInMonth); j++){
                if([appSettings.arrDay count] > j){
                    CellData * temp = [appSettings.arrDay objectAtIndex:j];
                    if([temp.number intValue] == day){
                        cur = temp;
                        break;
                    }
                }
            }
        }
    
    }
    
    
    for (UIView *view in [self subviews])
    {
        if([view tag] == 4)
            [view removeFromSuperview];
    }
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for(int i = 0; i < [cur.events count]; i++){
        EventData * temp = [cur.events objectAtIndex:i];
        if(![arr containsObject:temp.catId])
            [arr addObject:temp.catId];
    }
    
    int width = self.frame.size.width;
    for(int i = 0; i < [arr count]; i++){
        NSString * cId = [arr objectAtIndex:i];
        UIView * circleViews = [[UIView alloc] initWithFrame:CGRectMake(width - 10 - 12*i, 0, 8, 8)];
        circleViews.layer.cornerRadius = 4;
        circleViews.backgroundColor = [self getColor:cId];
        circleViews.tag = 4;
        [self addSubview:circleViews];
        
    }
    [arr removeAllObjects];
    
}

- (void)didTouch
{
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
    if(!self.isOtherMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
        
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextMonth];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousMonth];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    
    if(selected){
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelected];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorSelected];
        }
        else{
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelectedOtherMonth];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorSelectedOtherMonth];
        }
        
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }
    else if([self isToday]){
        if(!self.isOtherMonth){
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorToday];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorToday];
        }
        else{
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorTodayOtherMonth];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorTodayOtherMonth];
        }
    }
    else{
        if(!self.isOtherMonth){
            
            if([self isWeekend]){
                textLabel.textColor = [UIColor colorWithRed:216.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1];
            }
            else
                textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColor];
        }
        else{
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            dotView.color = [self.calendarManager.calendarAppearance dayDotColorOtherMonth];
        }
        
        opacity = 0.;
    }
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    dotView.hidden = ![self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:self.date];
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    [self setEvents:self.date];
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
