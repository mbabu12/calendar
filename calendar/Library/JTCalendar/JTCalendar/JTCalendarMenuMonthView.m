//
//  JTCalendarMenuMonthView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarMenuMonthView.h"

@interface JTCalendarMenuMonthView(){
    UILabel *textLabel;
    UILabel * yearLabel;
}

@end

@implementation JTCalendarMenuMonthView


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

- (void)commonInit
{
    {
        textLabel = [UILabel new];
        [self addSubview:textLabel];
        
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        yearLabel = [UILabel new];
        [self addSubview:yearLabel];
        
        yearLabel.textAlignment = NSTextAlignmentCenter;
        [yearLabel setHidden:NO];
        yearLabel.font = [yearLabel.font fontWithSize:10];
        
    }
}

- (void)setMonthIndex:(NSInteger)monthIndex
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
    }

    while(monthIndex <= 0){
        monthIndex += 12;
    }
    
    textLabel.text = [[dateFormatter standaloneMonthSymbols][monthIndex - 1] capitalizedString];
 
}

- (void)setYear:(NSInteger)year{
    NSString *yearText = [NSString stringWithFormat:@"%d", year];
    [yearLabel setText:yearText];
}

- (void)layoutSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    yearLabel.frame = CGRectMake(0, 18, self.frame.size.width, self.frame.size.height);

    // No need to call [super layoutSubviews]
}

- (void)reloadAppearance
{
    textLabel.textColor = self.calendarManager.calendarAppearance.menuMonthTextColor;
    textLabel.font = self.calendarManager.calendarAppearance.menuMonthTextFont;
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
